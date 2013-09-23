class Users::RegistrationsController < Devise::RegistrationsController

	def new
		build_resource({company: Company.new})
		respond_with self.resource
	end

private
	def sign_up_params
		allow = [:name, :email, :password, :password_confirmation, company_attributes: [:name]]
		params.require(:user).permit(allow)
	end
end