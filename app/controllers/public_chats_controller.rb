class PublicChatsController < ApiController
  respond_to :json
  before_action :public_chats_permissible?
  before_action :set_device

  def show
    unless user_signed_in? || @device&.chat&.present?
      @device.build_chat(public_assistant: true)
      @device.save
    end

    render json: {
      status: { code: 200 },
      data: ChatSerializer.new(@device.chat, params: { welcome_flag: true }).serializable_hash[:data]
    }, status: :ok
  end

  def update
    @chat = @device.chat
    return render json: {
      status: { code: 403, message: 'You have exceeded the free advice quota. Signup to continue' },
      data: ChatSerializer.new(@chat).serializable_hash[:data]
    }, status: :forbidden if @chat.reached_message_limit?

    run_id = @chat.make_messaging_updates(chat_params[:message])

    render json: {
      status: { code: 200 },
      data: ChatSerializer.new(@chat, params: { run_id: run_id}).serializable_hash[:data]
    }, status: :ok
  end

  private

  def set_device
    @device = Device.includes(:chat).find_or_initialize_by(device_token: device_param)
  end

  def chat_params
    params.require(:chat).permit(:chat_id, :message)
  end

  def device_param
    params.permit(:device_token)[:device_token].to_s
  end

  def public_chats_permissible?
    return render json: {
      status: { code: 403, message: "Public Chats not allowed." },
    }, status: :forbidden unless Setting.find_by(name: "public_access").value == "true"
  end
end
