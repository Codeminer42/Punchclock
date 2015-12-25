class DashboardController < ApplicationController
  def index

  end

  def sheets
    @punches = current_user.punches.group_by(&:date)
    render json: Hash[@punches.map{ |k, v| [k, v.to(1).map(&:sheet)] }]
  end
end
