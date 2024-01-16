# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  skip_before_action :verify_authenticity_token
  respond_to :json

  private

  def respond_with(current_user, _opts = {})
    if resource.persisted?
      resource.assign_public_chat(params[:user][:device_token].to_s)

      render json: {
        status: { code: 200, message: 'Signed up successfully.' },
        data: UserSerializer.new(current_user).serializable_hash[:data]
      }, status: :ok
    else
      render json: {
        status: {message: "User couldn't be created. #{current_user.errors.full_messages.to_sentence}"}
      }, status: :unprocessable_entity
    end
  end
end
