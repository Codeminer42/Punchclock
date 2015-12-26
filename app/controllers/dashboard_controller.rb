class DashboardController < ApplicationController
  def index

  end

  def sheets
    @punches = current_user.punches.group_by(&:date)
    render json: Hash[@punches.map{ |k, v| [k, v.to(1).map(&:sheet)] }]
  end

  def save
    deletes = Array.wrap(params['delete']).concat(params['add'].keys)
    @punches = current_user.punches

    @punches.transaction do
      @punches.by_days(deletes).delete_all if deletes.any?
      @punches.where({
        company: Company.first
      }).create(bulk_params(params['add'])) if params['add'].any?
    end
    render json: {}
  end

  protected

  def bulk_params(param)
    param.values.flatten.map{|p| p.slice :from, :to, :project_id }
  end
end
