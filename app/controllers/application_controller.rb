# frozen_string_literal: true

class ApplicationController < ActionController::Base
  respond_to :html, :json
  before_action :configure_permitted_parameters, if: :devise_controller?

  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: exception.message
  end

  # https://github.com/plataformatec/devise/issues/3461
  rescue_from ActionController::InvalidAuthenticityToken do |_exception|
    if devise_controller?
      redirect_to root_path, alert: I18n.t('devise.failure.already_logged_out')
    else
      raise
    end
  end

  def access_denied(exception)
    redirect_to after_sign_in_path_for(current_user), alert: exception.message
  end

  def authenticate_admin_user!
    unless !current_user.nil? && current_user.has_admin_access?
      redirect_to root_path, alert: I18n.t('devise.failure.access_denied')
    end
  end

  def after_sign_in_path_for(user)
    user_return_to = session.fetch(:user_return_to, '')
    return user_return_to if user_return_to.include?(oauth_authorization_path)

    return admin_dashboard_path if user.has_admin_access?

    root_path
  end

  def current_user
    UserDecorator.decorate(super) unless super.nil?
  end

  private

  def current_company
    @current_company ||= current_user.company
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: %i[email password otp_attempt])
  end
end
