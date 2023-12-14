class PublicChatsController < ApplicationController
  respond_to :json
  before_action :set_device

  def show
    welcome_message = ""
    unless @device.persisted?
      @device.create_public_chat
      welcome_message = "Hello, what is your health related question? Tell me your symptoms or ask me general health questions like a lab result or what does diastolic pressure mean."
    end

    render json: {
      status: { code: 200 },
      data: ChatSerializer.new(@device, params: {welcome_message: welcome_message}).serializable_hash[:data]
    }, status: :ok
  end


  def update
    return render json: {
      status: { code: 403, message: 'You have exceeded the free advice quota. Signup to continue' },
      data: ChatSerializer.new(@device).serializable_hash[:data]
    }, status: :forbidden if @device.reached_message_limit?

    OpenaiApiService.create_message(@device.chat_id, chat_params[:message])
    OpenaiApiService.run_chat(@device.chat_id)
    @device.increment_message_count

    render json: {
      status: { code: 200 },
      data: ChatSerializer.new(@device).serializable_hash[:data]
    }, status: :ok
  end

  private

  def set_device
    @device = Device.find_or_initialize_by(device_token: device_param)
  end

  def chat_params
    params.require(:chat).permit(:chat_id, :message)
  end

  def device_param
    params.permit(:device_token)[:device_token]
  end
end
