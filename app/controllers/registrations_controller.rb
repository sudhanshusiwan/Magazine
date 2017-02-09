class RegistrationsController < Devise::RegistrationsController

  private

  # Added extra parameter name for signup
  def sign_up_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  # Added extra parameter name for update
  def account_update_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :current_password)
  end
end