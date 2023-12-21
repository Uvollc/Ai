class ChatsController < ApplicationController
  respond_to :json
  include RackSessionsFix

  before_action :authenticate_user!
  # before_action :get_subscription_status, except: %i[index show]
  before_action :get_chat, except: %i[index create]

  def create
    @chat = current_user.create_chat

    render json: {
      status: { code: 200, message: 'Chat created successfully' },
      data: ChatSerializer.new(@chat).serializable_hash[:data]
    }, status: :ok
  end

  def index
    @chat_list = current_user.user_chats

    render json: {
      status: { code: 200 },
      data: ChatSerializer.new(@chat_list).serializable_hash[:data]
    }, status: :ok
  end

  def show
    render json: {
      status: { code: 200 },
      data: ChatSerializer.new(@chat).serializable_hash[:data]
    }, status: :ok
  end

  def update
    OpenaiApiService.create_message(@chat.chat_id, chat_params[:message])
    OpenaiApiService.run_chat(@chat.chat_id)

    render json: {
      status: { code: 200 },
      data: ChatSerializer.new(@chat).serializable_hash[:data]
    }, status: :ok
  end

  def destroy
    OpenaiApiService.delete_chat(@chat.chat_id)
    @chat.destroy

    render json: {
      status: { code: 200, message: 'Chat deleted successfully' },
    }, status: :ok
  end

  private

  def chat_params
    params.require(:chat).permit(:message)
  end

  def get_subscription_status
    return render json: {
      status: { code: 403, message: 'You have exceeded the free advice quota. Subscribe to continue' },
    }, status: :forbidden unless current_user.valid_subscription?
  end

  def get_chat
    @chat = UserChat.find_by(user_id: current_user.id, chat_id: params[:id])

    return render json: {
      status: { code: 404, message: 'No chat found for given id' },
    }, status: :not_found unless @chat.present?

    @chat
  end
end
