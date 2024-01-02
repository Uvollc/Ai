class ApiController < ActionController::API

  def prompts
    @prompts = Prompt.order(order: :asc)

    render json: {
      status: { code: 200 },
      data: PromptSerializer.new(@prompts).serializable_hash[:data]
    }, status: :ok
  end
end
