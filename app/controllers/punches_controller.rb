class PunchesController < InheritedResources::Base

  before_action :authenticate_user!
  load_and_authorize_resource except: [:create]
  before_action :user_projects

  def index
    @punches_filter_form = PunchesFilterForm.new(params[:punches_filter_form])
    @search = @punches_filter_form.apply_filters(scopped_punches).search(params[:q])

    @search.sorts = 'from desc' if @search.sorts.empty?
    @punches = @search.result.decorate
    index!
  end

  def import_csv
    current_user.import_punches import_csv_params[:archive].path
    redirect_to punches_path, notice: "Finished importing punches."
  rescue => e
    redirect_to punches_path, alert: "Error while importing punches."
  end

  def new
    @punch = Punch.new(company_id: current_user.company_id, user_id: current_user.id, project: last_user_project)
    @punch.build_comment
  end

  def edit
    @punch = Punch.find(params[:id])
    @punch.build_comment if @punch.comment.nil?
  end

  def create
    @punch = current_user.punches.new(sanitized_params)
    @punch.company_id = current_user.company_id
    authorize! :create, @punch
    if @punch.save
      flash[:notice] = "Punch created successfully!"
      redirect_to punches_path
    else
      render action: :new
    end
  end

  def update
    @punch = scopped_punches.find params[:id]
    authorize! :update, Comment unless sanitized_params[:comments_attributes].nil?
    if @punch.update(sanitized_params)
      flash[:notice] = "Punch updated successfully!"
      redirect_to punches_path
    else
      render action: :edit
    end
  end

  private
  def sanitized_params
    punch_data = {}

    punch_params.each do |k,v|
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

    if punch_data[:comment_attributes]
      punch_data[:comment_attributes][:user_id] = current_user.id
      punch_data[:comment_attributes][:company_id] = current_user.company_id
      punch_data[:comment_attributes][:_destroy] = true unless punch_data[:comment_attributes][:text].present?
    end

    punch_data
  end

  def punch_params
    allow = [:from, :to, :project_id, :attachment, :remove_attachment, comment_attributes: [:id, :text]]
    params.require(:punch).permit(allow)
  end

  def verify_ownership
    @punch = Punch.find params[:id]
    head 403 unless @punch.user_id == current_user.id
  end

  def user_projects
    @projects = current_user.company.projects
  end

  def scopped_punches
    current_user.is_admin? ? current_user.company.punches : current_user.punches
  end

  def last_user_project
    Punch.where(user_id: current_user).last.try(:project)
  end

  def import_csv_params
    params.require(:archive_csv).permit(:archive)
  end
end
