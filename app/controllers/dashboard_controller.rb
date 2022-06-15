class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def sheets
    @punches = current_user.punches.group_by(&:date)
    render json: Hash[@punches.map{ |k, v| [k.to_s(:db), v.to(1).map(&:sheet)] }]
  end

  def save
    @punches = current_user.punches
    company = current_user.company
    additions = bulk_params(params_add)
    deletions = Array.wrap(punch_params['delete']).concat(params_add.keys)

    @punches_transaction = CreatePunchesInBatchService.call(@punches, company, additions, deletions)

    if @punches_transaction.success?
      head :created
    else
      head :unprocessable_entity
    end
  end

  protected

  def punch_params
    params.permit(add: {}, delete: [])
  end

  def params_add
    @params_add ||= punch_params['add']
  end

  def bulk_params(param)
    param.values.flatten.map{|p| p.slice :from, :to, :project_id }
  end
end
