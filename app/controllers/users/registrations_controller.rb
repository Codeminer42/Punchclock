class Users::RegistrationsController < Devise::RegistrationsController

	def create
		super
	end

private
	def user_params
		params.permit(user: [:name, :email, :company, :password, :password_confirmation])
	end
end