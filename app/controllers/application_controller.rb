class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: exception.message
  end

=begin
  def current_ability
    if request.fullpath =~ /\/admin/
      @current_ability ||= AdminAbility.new(current_admin_user)
    else
      @current_ability ||= UserAbility.new(current_user)
    end
  end
=end
end
