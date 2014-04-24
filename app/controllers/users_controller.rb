class UsersController < ApplicationController
  before_action :authenticate_user!

  def update
    @user = current_user
    @user.update(user_params)
    respond_with @user
  end

  private

  def user_params
    allow = [:name, :email]
    allow << :hour_cost if current_user.is_admin?
    params.require(:user).permit(allow)
  end
end
