class PasswordsController < ApplicationController
	def edit
		:authenticate_user!
	end

	def update
		if current_user.update_with_password(user_params[:user])
			sign_in(current_user, bypass: true)
			flash[:notice] = "Password updated successfully!"
			redirect_to edit_user_path(current_user)
		else
			flash[:alert] = current_user.errors.full_messages.first
			redirect_to users_account_password_edit_path
		end
	end

private
	def user_params
		params.permit(user: [:current_password, :password, :password_confirmation])
	end
end
