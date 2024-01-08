class ChatsController < ApiController
  respond_to :json

  before_action :authenticate_user!
  before_action :get_subscription_status, except: %i[index show]
  before_action :get_chat, except: %i[index create]

  def create
    user_chats_count = current_user.chats.count
    return action_not_allowed if (current_user.pending? && user_chats_count > 0)
    @chat = user_chats_count == 0 ? current_user.chats.create(public_assistant: true) : current_user.chats.create

    render json: {
      status: { code: 200, message: 'Chat created successfully' },
      data: ChatSerializer.new(@chat, params: { welcome_flag: true }).serializable_hash[:data]
    }, status: :ok
  end

  def index
    @chat_list = current_user.chats.order(updated_at: :desc)

    render json: {
      status: { code: 200 },
      data: ChatSerializer.new(@chat_list).serializable_hash[:data]
    }, status: :ok
  end

  def show
    render json: {
      status: { code: 200 },
      data: ChatSerializer.new(@chat, params: { welcome_flag: true }).serializable_hash[:data]
    }, status: :ok
  end

  def update
    run_id = @chat.make_messaging_updates(chat_params[:message])

    render json: {
      status: { code: 200 },
      data: ChatSerializer.new(@chat, params: {run_id: run_id}).serializable_hash[:data]
    }, status: :ok
  end

  def destroy
    return action_not_allowed if current_user.pending?
    @chat.destroy

    render json: {
      status: { code: 200, message: 'Chat deleted successfully' },
    }, status: :ok
  end

  private

  def chat_params
    params.require(:chat).permit(:message)
  end

  def action_not_allowed
    return render json: {
      status: { code: 403, message: 'You do not have permission for this action. Upgrade to continue' },
    }, status: :forbidden
  end

  def get_subscription_status
    return render json: {
      status: { code: 403, message: 'You have exceeded the free advice quota. Subscribe to continue' },
    }, status: :forbidden unless current_user.valid_subscription?
  end

  def get_chat
    @chat = Chat.find_by(chatable_id: current_user.id, thread_id: params[:id])

    return render json: {
      status: { code: 404, message: 'No chat found for given id' },
    }, status: :not_found unless @chat.present?

    @chat
  end
end
