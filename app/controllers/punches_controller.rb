class PunchesController < InheritedResources::Base
  before_action :authenticate_user!
  before_action :user_projects
  before_action :verify_ownership, only: [:show, :edit, :update, :destroy]

  def index
    if params[:q].present? && params[:q][:"from_gteq(1i)"]
      t = Time.new(params[:q][:"from_gteq(1i)"].to_i,
                   params[:q][:"from_gteq(2i)"].to_i,
                   params[:q][:"from_gteq(3i)"].to_i).end_of_month
    else
      t = Time.now.end_of_month
    end

    @search = search_punches(t)
    @search.sorts = 'from desc' if @search.sorts.empty?
    @punches = @search.result
    index!
  end

  def create
    @punch = current_user.punches.new(sanitized_params)
    @punch.company_id = current_user.company_id
    authorize! :create, @punch
    if @punch.save
      flash[:notice] = "Punch created successfully!"
      redirect_to punch_url(@punch)
    else
      render :action => :new
    end
  end

  def update
    @punch = current_user.punches.find params[:id]
    if @punch.update(sanitized_params)
      flash[:notice] = "Punch updated successfully!"
      redirect_to punch_url(@punch)
    else
      render action: :edit
    end
  end

private
  def sanitized_params
    punch_data = {}

    permitted_params[:punch].each do |k,v|
      punch_data[k.to_sym] = v
    end

    when_data = params[:when_day].to_s.split('-')

    if when_data.present?
      punch_data[:"from(1i)"] = when_data[0]
      punch_data[:"from(2i)"] = when_data[1]
      punch_data[:"from(3i)"] = when_data[2]

      punch_data[:"to(1i)"] = when_data[0]
      punch_data[:"to(2i)"] = when_data[1]
      punch_data[:"to(3i)"] = when_data[2]
    else
      punch_data[:"from(1i)"] = ''
      punch_data[:"from(2i)"] = ''
      punch_data[:"from(3i)"] = ''
      punch_data[:"from(4i)"] = ''
      punch_data[:"from(5i)"] = ''

      punch_data[:"to(1i)"] = ''
      punch_data[:"to(2i)"] = ''
      punch_data[:"to(3i)"] = ''
      punch_data[:"to(4i)"] = ''
      punch_data[:"to(5i)"] = ''
    end

    punch_data
  end

  def permitted_params
    params.permit(punch: [:from, :to, :project_id, :attachment, :remove_attachment])
  end

  def verify_ownership
    @punch = Punch.find params[:id]
    head 403 unless @punch.user_id == current_user.id
  end

  def user_projects
    @projects = current_user.company.projects
  end

  def search_punches(t)
    if current_user.is_admin?
      current_user.company.punches.where("\"to\" < ?", t).search(params[:q])
    else
      current_user.punches.where("\"to\" < ?", t).search(params[:q])
    end
  end
end
