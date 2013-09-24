class Users::RegistrationsController < Devise::RegistrationsController

	def new
		build_resource({company: Company.new, is_admin: true})
		respond_with self.resource
	end
private
	def sign_up_params
		allow = [:name, :email, :password, :password_confirmation, company_attributes: [:name]]
		params.require(:user).permit(allow)
	end

	def sign_up(resource_name, resource)
    NotificationMailer.notify_successful_signup(resource).deliver
    sign_in(resource_name, resource)
  end
end