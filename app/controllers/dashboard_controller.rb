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
        project: Project.first,
        company: Company.first}).create bulk_params(params['add'])
    end
    render json: {}
  end

  protected

  def bulk_params(param)
    param.map do |date, sheet|
      sheet.map do |time_range|
        from, to = time_range.split('-')
        {from: "#{date} #{from}", to: "#{date} #{to}"}
      end
    end.flatten
  end
end
