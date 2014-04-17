module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    skip_before_action :verify_authenticity_token

    def all
      @user = find_user
      if @user.persisted?
        flash[:notice] = I18n.t(
          'devise.omniauth_callbacks.success', kind: 'GoogleApps'
        )
        sign_in_and_redirect @user, event: :authentication
      else
        redirect_to controller: :home, action: :index
      end
    end

    alias_method :google_apps, :all

    protected

    def find_user
      User.find_for_googleapps_oauth(
        request.env['omniauth.auth'], current_user
      )
    end
  end
end
