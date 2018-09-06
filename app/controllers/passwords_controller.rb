class PasswordsController < ApplicationController
  before_action :authenticate_user!

  def edit
  end

  def update
    if current_user.update_with_password(user_params)
      redirect_to edit_user_path
    else
      flash_errors('update')
      render :edit
    end
  end

  private

  def flash_errors(scope)
    flash.now[:alert] = "#{alert_message(scope)} #{error_message}"
  end

  def alert_message(scope)
    I18n.t(:alert, scope: [:flash, :actions, scope], resource_name: "Password")
  end

  def errors
    current_user.errors.full_messages.join('. ')
  end

  def error_message
    I18n.t(:errors, scope: :flash, errors: errors)
  end

  def user_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end
end
