# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :store_user_location!, if: :storable_location?

  respond_to :html, :json
  before_action :configure_permitted_parameters, if: :devise_controller?

  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: exception.message
  end

  # https://github.com/plataformatec/devise/issues/3461
  rescue_from ActionController::InvalidAuthenticityToken do |_exception|
    raise unless devise_controller?

    redirect_to root_path, alert: I18n.t('devise.failure.already_logged_out')
  end

  def access_denied(exception)
    redirect_to default_redirect_path, alert: exception.message
  end

  def authenticate_admin_user!
    return unless cannot?(:read, ActiveAdmin)

    redirect_to root_path, alert: I18n.t('devise.failure.access_denied')
  end

  def after_sign_in_path_for(_user)
    stored_location_for(:request) || default_redirect_path
  end

  def current_user
    UserDecorator.decorate(super) unless super.nil?
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: %i[email password otp_attempt])
  end

  private

  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  def store_user_location!
    store_location_for(:request, request.fullpath)
  end

  def default_redirect_path
    if can? :read, ActiveAdmin
      admin_dashboard_path
    else
      root_path
    end
  end

  def flash_errors(scope, resource_name, error_message)
    flash.now[:alert] = "#{alert_message(scope, resource_name)} #{error_message}"
  end

  def alert_message(scope, resource_name)
    I18n.t(:alert, scope: "flash.actions.#{scope}", resource_name:)
  end
end
