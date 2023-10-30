class TalksController < ApplicationController
  before_action :authenticate_user!

  def index
    @talks = current_user.talks.page(params[:page])
  end
end
