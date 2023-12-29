class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  def authenticate_admin!
    if admin_user_signed_in?
      admin_root_path
    else
      redirect_to new_admin_user_session_path
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name email password password_confirmation])
    devise_parameter_sanitizer.permit(:login, keys: %i[email password])
  end
end
