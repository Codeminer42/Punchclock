class PasswordsController < ApplicationController
  before_action :authenticate_user!
  self.responder = PasswordsResponder

  def update
    current_user.update_with_password(user_params[:user])
    respond_with current_user, location: edit_user_path(current_user)
  end

  private

  def user_params
    params.permit(user: %w(current_password password password_confirmation))
  end
end
