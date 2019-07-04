# frozen_string_literal: true
class ApplicationController < ActionController::Base
  respond_to :html, :json

  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: exception.message
  end

  # https://github.com/plataformatec/devise/issues/3461
  rescue_from ActionController::InvalidAuthenticityToken do |exception|
    if devise_controller?
      redirect_to root_path, alert: 'Already logged out'
    else
      raise
    end
  end

  def authenticate_admin_user!
    redirect_to root_path unless !current_admin_user.nil? && current_admin_user.access_admin?
  end

  def after_sign_in_path_for(user)
    !user.nil? && user.access_admin? ? admin_dashboard_path : root_path 
  end

  private

  def current_admin_user
    current_user
  end

  def current_company
    @current_company ||= current_user.company 
  end
end
