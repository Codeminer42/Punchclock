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
    unless !current_admin_user.nil? && current_admin_user.has_admin_access?
      redirect_to root_path, alert: "Acesso negado"
    end
  end

  def after_sign_in_path_for(user)
    if (user.admin? && user.administrative?) || user.super_admin?
      admin_dashboard_path 
    else
      root_path 
    end
  end

  private

  def current_admin_user
    current_user
  end

  def current_company
    @current_company ||= current_user.company 
  end
end
