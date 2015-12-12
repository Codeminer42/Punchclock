class PunchesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource except: [:create]
  before_action :user_projects

  def index
    @punches_filter_form = PunchesFilterForm.new(params[:punches_filter_form])
    @search = @punches_filter_form.apply_filters(scopped_punches)
      .search(params[:q])

    @search.sorts = 'from desc' if @search.sorts.empty?
    @punches = @search.result.decorate
    respond_with @punches
  end

  def import_csv
    current_user.import_punches import_csv_params[:archive].path
    redirect_to punches_path, notice: 'Finished importing punches.'
  rescue
    redirect_to punches_path, alert: 'Error while importing punches.'
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
    allow = %i(id from_time to_time when_day project_id attachment remove_attachment comment)
    params.require(:punch).permit(*allow)
  end

  def user_projects
    @projects = current_user.company.projects
  end

  def scopped_punches
    if current_user.is_admin?
      current_user.company.punches
    else
      current_user.punches
    end
  end

  def import_csv_params
    params.require(:archive_csv).permit(:archive)
  end
end
