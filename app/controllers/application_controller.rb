class ApplicationController < ActionController::Base
  responders :flash
  respond_to :html, :json

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: exception.message
  end

  private

  def ensure_admin!
    current_user.is_admin? or fail CanCan::AccessDenied
  end
end
