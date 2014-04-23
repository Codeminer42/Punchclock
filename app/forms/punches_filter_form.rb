class PunchesFilterForm
  extend ActiveModel::Naming
  include ActiveModel::Conversion

  attr_accessor :since, :until, :project_id, :user_id

  def initialize(params)
    params ||= {}
    @since = params[:since]
    @until = params[:until]
    @project_id = params[:project_id]
    @user_id = params[:user_id]
  end

  def persisted?
    false
  end

  def apply_filters(relation)
    relation = filter_date relation
    relation = relation.where(project_id: @project_id) if @project_id.present?
    relation = relation.where(user_id: @user_id) if @user_id.present?
    relation
  end

  protected

  def filter_date(relation)
    if @since.present?
      since_date = Date.strptime(@since, '%Y-%m-%d')
      relation = relation.since(since_date)
    end

    if @until.present?
      until_date = Date.strptime(@until, '%Y-%m-%d')
      relation = relation.until(until_date)
    end

    relation
  end
end
