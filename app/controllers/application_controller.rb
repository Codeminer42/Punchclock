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

  private 

  def current_company
    @current_company ||= current_user.company 
  end
end
