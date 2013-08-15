class PunchesController < InheritedResources::Base
  before_action :authenticate_user!
  before_action :verify_ownership, only: [:show, :edit, :update, :destroy]

  def index
    if params[:q].present? && params[:q][:"from_gteq(1i)"]
      t = Time.new(params[:q][:"from_gteq(1i)"].to_i,
                   params[:q][:"from_gteq(2i)"].to_i,
                   params[:q][:"from_gteq(3i)"].to_i).end_of_month
    else
      t = Time.now.end_of_month
    end
    @search = Punch.where(user_id: current_user.id)
                   .where("\"to\" < ?", t)
                   .search(params[:q])
    @search.sorts = 'from desc' if @search.sorts.empty?
    @punches = @search.result
    index!
  end

  def create
    @punch = current_user.punches.new(sanitized_params)
    if @punch.save
      redirect_to punch_url(@punch)
    else
      render :action => :new
    end
  end

  def update
    @punch = current_user.punches.find params[:id]
    if @punch.update(sanitized_params)
      redirect_to punch_url @punch
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
    punch_data[:"to(1i)"] = punch_data[:"from(1i)"]
    punch_data[:"to(2i)"] = punch_data[:"from(2i)"]
    punch_data[:"to(3i)"] = punch_data[:"from(3i)"]
    punch_data
  end

  def permitted_params
    params.permit(punch: [:from, :to, :project_id])
  end

  def verify_ownership
    @punch = Punch.find params[:id]
    head 403 unless @punch.user_id == current_user.id
  end

end
