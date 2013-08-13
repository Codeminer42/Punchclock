class PunchesController < InheritedResources::Base
  before_action :authenticate_user!
  before_action :verify_ownership, only: [:show, :edit, :update, :destroy]

  def index
    @search = Punch.search(params[:q])
    @search.sorts = 'from desc' if @search.sorts.empty?
    @punches = @search.result
    index!
  end

  def create
    @punch = Punch.new
    set_time_and_project_from_params
    @punch.user_id = current_user.id
    create!
  end

  def update
    set_time_and_project_from_params
    update!
  end

private
  def set_time_and_project_from_params
    @punch.from = DateTime.new(params[:punch][:"from(1i)"].to_i,
                               params[:punch][:"from(2i)"].to_i,
                               params[:punch][:"from(3i)"].to_i,
                               params[:punch][:"from(4i)"].to_i,
                               params[:punch][:"from(5i)"].to_i)
    @punch.to = DateTime.new(params[:punch][:"from(1i)"].to_i,
                             params[:punch][:"from(2i)"].to_i,
                             params[:punch][:"from(3i)"].to_i,
                             params[:punch][:"to(4i)"].to_i,
                             params[:punch][:"to(5i)"].to_i)
    @punch.project_id = params[:punch][:project]
  end

  def permitted_params
    params.permit(punch: [:from, :to, :project_id])
  end

  def verify_ownership
    @punch = Punch.find params[:id]
    head 403 unless @punch.user_id == current_user.id
  end

end
