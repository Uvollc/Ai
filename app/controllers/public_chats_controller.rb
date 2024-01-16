class PublicChatsController < ApplicationController
  respond_to :json
  before_action :set_device

  def show
    unless @device.persisted?
      @device.build_chat
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

    OpenaiApiService.create_message(@chat.thread_id, chat_params[:message])
    run_id = OpenaiApiService.run_chat(@chat.thread_id)
    @chat.make_messaging_updates(chat_params[:message])

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
end
