module Users
  class InvitationsController < Devise::InvitationsController
    def create
      super { update_with_defaults }
    end

    protected

    def update_with_defaults
      resource.update_attributes({
        name: resource_params[:email][/(.*)@/, 1],
        company_id: current_user.company_id
      })
    end

    def update_resource_params
      allow = %i(name password password_confirmation invitation_token)
      params.require(:user).permit(allow)
    end
  end
end
