class UserAccountController < ApplicationController
	before_action :authenticate_user!
	before_action :authorize

	def edit
	end

	def update
	end

private
	def user_params
		params.permit(user: [:name, :email])
	end

	def authorize
		redirect_to root_path unless params[:id] == current_user.id.to_s
	end
end
