# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  skip_before_action :verify_authenticity_token

  respond_to :json

  private

  def respond_with(current_user, _opts = {})
    render json: {
      status: { code: 200, message: 'Logged in successfully.' },
      data: UserSerializer.new(current_user).serializable_hash[:data]
    }, status: :ok
  end

  def respond_to_on_destroy
    if request.headers['Authorization'].present?
      jwt_payload = JWT.decode(request.headers['Authorization'].split(' ').last, ENV['DEVISE_JWT_SECRET_KEY']).first
      current_user = User.find(jwt_payload['sub'])
    end

    if current_user
      render json: {
        status: 200,
        message: 'Logged out successfully.'
      }, status: :ok
    else
      render_no_active_session
    end

  rescue JWT::ExpiredSignature => e
    render_no_active_session
  end

  private

  def render_no_active_session
    render json: {
        status: 401,
        message: "Couldn't find an active session."
      }, status: :unauthorized
  end
end
