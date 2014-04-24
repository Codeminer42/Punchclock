class ApplicationController < ActionController::Base
  respond_to :html, :json
  self.responder = ApplicationResponder

  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: exception.message
  end

  private

  def ensure_admin!
    current_user.is_admin? || fail(CanCan::AccessDenied)
  end
end
