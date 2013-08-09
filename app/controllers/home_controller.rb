class HomeController < ApplicationController
  # before_filter :authenticate_member!, except: "users/sign_in"

  def index

  end

  def logout
    reset_session
    redirect_to action: :index
  end

  private

  def authenticate_member!
    redirect_to(controller: :"devise/sessions", :action => :new) unless user_signed_in?
  end
end