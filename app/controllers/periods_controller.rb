class PeriodsController < ApplicationController
  def index
    @periods = end_of_chain.load.decorate
    respond_with @periods
  end

  def show
    @period = end_of_chain.find(params[:id]).decorate
    respond_with @period
  end

  protected

  def end_of_chain
    current_user.company.periods
  end
end
