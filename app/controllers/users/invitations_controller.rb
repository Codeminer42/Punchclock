class Users::InvitationsController < Devise::InvitationsController
	 def create
    super
     # skip validations
    if resource.errors.blank?
      resource.update_attribute(:name, resource_params[:email].split('@').first)
      resource.update_attribute(:is_admin, false)
      resource.update_attribute(:company_id, current_user.company_id)
    end
 	end

  protected

  def update_resource_params
  	 allow = [:name, :password, :password_confirmation, :invitation_token]
    params.require(:user).permit(allow)
  end
end
