class UserAccountController < ApplicationController
	before_action :authenticate_user!
	before_action :authorize

	def edit
	end

	def update
		if current_user.update(user_params[:user])
			flash[:notice] = "User updated successfully!"
		else
			flash[:alert] = current_user.errors.full_messages.first
		end
		redirect_to edit_user_path(current_user)
	end

private
	def user_params
		params.permit(user: [:name, :email])
	end

	def authorize
		redirect_to root_path unless params[:id] == current_user.id.to_s
	end
end
