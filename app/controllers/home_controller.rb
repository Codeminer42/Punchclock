class HomeController < ApplicationController
  before_action :go_to_punches, :except => :logout

  def index; end

  def logout
    reset_session
    redirect_to action: :index
  end

private

  def go_to_punches
    redirect_to(punches_path) if user_signed_in?
  end

end