class ApplicationController < ActionController::Base
  respond_to :html, :json
  self.responder = ApplicationResponder

  protect_from_forgery with: :exception

  before_action :only_active_users

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: exception.message
  end

  private

  def ensure_admin!
    current_user.is_admin? || fail(CanCan::AccessDenied)
  end

  def only_active_users
    if user_signed_in? && !current_user.active?
      sign_out current_user
      fail(CanCan::AccessDenied)
    end
  end
end
