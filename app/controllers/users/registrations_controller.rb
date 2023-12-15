# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  include RackSessionsFix
  respond_to :json

  private

  def respond_with(current_user, _opts = {})
    if resource.persisted?
      #register_chat for when the user was not registered i.e. via device_token
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
