class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_filter :verify_authenticity_token

  def all
    @user = User.find_for_googleapps_oauth(request.env["omniauth.auth"], current_user)
    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "GoogleApps"
      sign_in_and_redirect @user, :event => :authentication
    else
      redirect_to controller: :home, action: :index
    end
  end

  alias_method :google_apps, :all
end
