class TalksController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound do
    redirect_to '/404'
  end

  before_action :authenticate_user!

  def index
    @talks = current_user.talks.page(params[:page])
  end

  def show
    @talk = current_user.talks.find(params[:id])
  end
end
