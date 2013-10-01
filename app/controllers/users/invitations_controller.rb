class Users::InvitationsController < Devise::InvitationsController

	def create
    super
    #skip validations
    self.resource.update_attribute(:is_admin, false)
    self.resource.update_attribute(:company_id, current_user.company_id)
	end

protected

  def update_resource_params
  	allow = [:name, :password, :password_confirmation, :invitation_token]
    params.require(:user).permit(allow)
  end
end