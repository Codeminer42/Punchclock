class UsersController < ApplicationController
	before_action :authenticate_user!

	def account
	end

	def update_user
		current_user.update_attribute('name',permitted_params[:user][:name])
		current_user.update_attribute('email',permitted_params[:user][:email])
		if current_user.save
			flash[:notice] = "User updated successfully!"
		else
			flash[:alert] = current_user.errors.full_messages.first
		end
		redirect_to user_account_path
	end

	def account_password
	end

	def update_password
		if current_user.update_with_password(current_password: permitted_params[:user][:current_password],
																				 password:permitted_params[:user][:password],
																				 password_confirmation:permitted_params[:user][:password_confirmation])
			sign_in(current_user, bypass: true)
			flash[:notice] = "Password updated successfully!"
			redirect_to user_account_path
		else
			flash[:alert] = current_user.errors.full_messages.first
			redirect_to user_account_password_path
		end
	end

private
  def permitted_params
    params.permit(user: [:name, :email, :current_password, :password, :password_confirmation])
  end
end
