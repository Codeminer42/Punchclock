class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
  end

  def edit
  end

  def update
    current_user.update(user_params)
    respond_with current_user
  end

  private

  def user_params
    params.require(:user).permit(:name, :email)
  end
end
