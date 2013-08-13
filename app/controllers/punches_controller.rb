class PunchesController < InheritedResources::Base
  before_action :authenticate_user!

  def index
    @search = Punch.search(params[:q])
    @search.sorts = 'from desc' if @search.sorts.empty?
    @punches = @search.result
    index!
  end

  def create
    @punch = Punch.new
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
    @punch.user_id = current_user.id

    create!
  end

  def update
    @punch = Punch.find params[:id]
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
    @punch.user_id = current_user.id

    update!
  end

private

  def permitted_params
    params.permit(punch: [:from, :to, :project_id])
  end

end
