require 'qr_code_generator_service'

class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
  end

  def edit
  end

  def update
    current_user.attributes = user_params
    if current_user.save
      redirect_to root_path, notice: "User updated"
    else
      render :edit
    end
  end

  def twofactor
    generate_otp_secret
    @img = gen_qr_code(current_user.otp_secret, current_user.email)
    enable_two_factor
    render :enabletwofactor
  end

  private
  def generate_otp_secret
    current_user.otp_secret = User.generate_otp_secret
  end

  def enable_two_factor
    current_user.otp_required_for_login = true
    current_user.save!
  end
  
  def user_params
    params.require(:user).permit(:name, :email)
  end
end
