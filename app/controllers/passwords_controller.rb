class PasswordsController < ApplicationController
  before_action :authenticate_user!

  def update
    if current_user.update_with_password(user_params[:user])
      password_changed!
    else
      flash.now[:alert] = current_user.errors.full_messages.first
      render :edit
    end
  end

  private

  def password_changed! # MOVEME to a responder, please! pleeeeeeease!
    sign_in(current_user, bypass: true)
    flash[:notice] = 'Password updated successfully!'
    NotificationMailer.notify_user_password_change(
      current_user, user_params[:user][:password]
    ).deliver
    redirect_to edit_user_path(current_user)
  end

  def user_params
    params.permit(user: [:current_password, :password, :password_confirmation])
  end
end
