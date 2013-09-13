class PasswordsController < ApplicationController
	def password
		:authenticate_user!
	end

	def update
	end

private
	def user_params
		params.permit(user: [:current_password, :password, :password_confirmation])
	end
end
