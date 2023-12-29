class UsersController < ApiController
  respond_to :json

  before_action :authenticate_user!

  def update_without_password
    @user = current_user
    if @user.update_without_password(user_params)
      bypass_sign_in(@user)
      render json: {
        status: { code: 200, message: 'Updated user successfully.' },
        data: UserSerializer.new(@user).serializable_hash[:data]
      }, status: :ok
    else
      render json: {
        status: {message: "User couldn't be updated. #{@user.errors.full_messages.to_sentence}"}
      }, status: :unprocessable_entity
    end
  end

  def deactivate
    @user = current_user
    if @user.soft_delete
      sign_out(@user)
      render json: {
        status: { code: 200, message: 'Deactivated user account successfully.' }
      }, status: :ok
    else
      render json: {
        status: {message: "User couldn't be deactivated. #{@user.errors.full_messages.to_sentence}"}
      }, status: :unprocessable_entity
    end
  end

  def update_password
    @user = current_user
    if @user.update_with_password(password_params)
      bypass_sign_in(@user)
      render json: {
        status: { code: 200, message: 'Updated password successfully.' },
        data: UserSerializer.new(@user).serializable_hash[:data]
      }, status: :ok
    else
      render json: {
        status: {message: "Password couldn't be updated. #{@user.errors.full_messages.to_sentence}"}
      }, status: :unprocessable_entity
    end
  end

  def update_avatar
    @user = current_user
    @user&.avatar&.purge
    @user.avatar.attach(avatar_param[:avatar])
    if @user.avatar.attached?
      render json: {
        status: { code: 200, message: 'Avatar attached successfully.' },
        data: UserSerializer.new(@user).serializable_hash[:data]
      }, status: :ok
    else
      render json: {
        status: {message: "Can't update avatar. #{@user.errors.full_messages.to_sentence}"}
      }, status: :unprocessable_entity
    end
  end

  private

  def password_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :phone, :email)
  end

  def avatar_param
    params.permit(:avatar)
  end
end
