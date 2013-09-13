class UsersController < ApplicationController
	before_action :authenticate_user!

	def account
	end

	def update_user
		current_user.update_attributes(name:params[:user][:name], email:params[:user][:email])
		if current_user.save
			flash[:notice] = "User updated successfully!"
		end
		redirect_to user_account_path
	end

	def account_password
	end

	def update_password
		current_user.update_attributes(password:params[:user][:password], password_confirmation:params[:user][:password_confirmation])
		if current_user.save
			flash[:notice] = "Password updated successfully!"
		end
		redirect_to user_account_path
	end

private
  def permitted_params
    params.permit(user: [:name, :email, :password, :password_confirmation])
  end
end
