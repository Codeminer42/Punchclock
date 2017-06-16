class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.all
    respond_with @users
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = current_user
    @user.update(user_params)
    respond_with @user
  end

  private

  def user_params
    allow = %i(name email)
    params.require(:user).permit(allow)
  end
end
