class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def sheets
    @punches = current_user.punches.group_by(&:date)
    render json: Hash[@punches.map{ |k, v| [k.to_s(:db), v.to(1).map(&:sheet)] }]
  end

  def save
    params_add_permit

    return head :bad_request if invalid_day_periods?

    deletes = Array.wrap(params['delete']).concat(@params_add.keys)
    @punches = current_user.punches

    @punches.transaction do
      @punches.by_days(deletes).delete_all if deletes.any?
      @punches.where(
        company: current_user.company
      ).create(bulk_params(@params_add)) if @params_add
    end
    head :created
  end

  protected

  def params_add_permit
    @params_add ||= params['add'].permit!
  end

  def bulk_params(param)
    param.values.flatten.map{|p| p.slice :from, :to, :project_id }
  end

  def invalid_day_periods?
    @params_add.to_h.one? { |_, periods| invalid_period?(periods) }
  end

  def invalid_period?(periods)
    morning, lunch = periods.map do |p|
      p.slice(:from, :to).transform_values { |v| DateTime.parse(v) }
    end
    
    expected_order = [morning[:from], morning[:to], lunch[:from], lunch[:to]]
    expected_order != expected_order.uniq.sort
  end
end
