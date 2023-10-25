class TalksController < ApplicationController
  before_action :authenticate_user!

  def index
    @talks = scoped_talks.page(params[:page])
  end

  private

  def scoped_talks
    current_user.talks
  end
end
