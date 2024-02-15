class ApiController < ActionController::API

  def prompts
    @prompts = Prompt.order(order: :asc)

    render json: {
      status: { code: 200 },
      data: PromptSerializer.new(@prompts).serializable_hash[:data]
    }, status: :ok
  end

  def public_access
    render json: {
      status: { code: 200 },
      data: { chat_access: Setting.find_by(name: "public_access").value }
    }, status: :ok
  end
end
