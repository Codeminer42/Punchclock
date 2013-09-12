class UsersController < ApplicationController
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
	end

private
  def permitted_params
    params.permit(user: [:name, :email])
  end
end
