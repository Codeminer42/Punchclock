class PasswordsController < ApplicationController
  before_action :authenticate_user!

  def edit
  end

  def update
    if current_user.update_with_password(user_params)
      redirect_to edit_user_path
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end
end
