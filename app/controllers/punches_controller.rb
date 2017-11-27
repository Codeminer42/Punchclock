class PunchesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource except: [:create]
  before_action :user_projects

  def index
    @punches_filter_form = PunchesFilterForm.new(params[:punches_filter_form])
    @search = @punches_filter_form.apply_filters(scopped_punches)
      .includes(:project)
      .search(params[:q])

    @search.sorts = 'from desc' if @search.sorts.empty?
    @punches = Pagination.new(@search.result).decorated(params)
    respond_with @punches
  end

  def new
    @punch = Punch.new
    respond_with @punch
  end

  def edit
    @punch = Punch.find(params[:id])
    respond_with @punch
  end

  def create
    @punch = Punch.new(punch_params)
    @punch.company_id = current_user.company_id
    @punch.user_id = current_user.id

    @punch.save
    respond_with @punch, location: punches_path
  end

  def update
    @punch = scopped_punches.find params[:id]
    @punch.update(punch_params)
    respond_with @punch, location: punches_path
  end

  def destroy
    @punch = Punch.find(params[:id])
    @punch.destroy
    respond_with @punch
  end

  private

  def punch_params
    allow = %i(id from_time to_time when_day project_id
      attachment remove_attachment comment extra_hour)
    params.require(:punch).permit(*allow)
  end

  def user_projects
    @projects = current_user.company.projects
  end

  def scopped_punches
    current_user.punches
  end
end
