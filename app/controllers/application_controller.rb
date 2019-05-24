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

  # before_action :authenticate_miner!

  # def after_sign_out_path_for(_resource_or_scope)
    # miner_login_path
  # end

  # def after_sign_in_path_for(_resource_or_scope)
    # current_user.admin? ? admin_root_path : miner_root_path
  # end

  # def access_denied(exception)
    # redirect_to root_path, alert: exception.message
  end

  private 

  def current_company
    @current_company ||= current_user.company 
  end
end
