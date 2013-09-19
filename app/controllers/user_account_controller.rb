class UserAccountController < ApplicationController
	before_action :authenticate_user!
	before_action :authorize

	def update
		if current_user.update(user_params[:user])
			flash.now[:notice] = "User updated successfully!"
		else
			flash.now[:alert] = current_user.errors.full_messages.first
		end
		render :edit
	end

private
	def user_params
		params.permit(user: [:name, :email])
	end

	def authorize
		redirect_to root_path unless params[:id] == current_user.id.to_s
	end
end
