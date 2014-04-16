class Users::RegistrationsController < Devise::RegistrationsController
	 def new
 		 build_resource(company: Company.new)
 		 respond_with resource
 	end

	 def create
    build_resource(sign_up_params)
    resource.is_admin = true
    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      render action: :new
    end
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
