class PunchesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource except: :create
  before_action :user_projects

  def index
    @punches_filter_form = PunchesFilterForm.new(params[:punches_filter_form])
    @search = @punches_filter_form.apply_filters(scopped_punches)
      .includes(:project)
      .ransack(params[:q])

    @search.sorts = 'from desc' if @search.sorts.empty?
    @punches = PunchesPaginationDecorator.new(params, @search.result)
  end

  def new
    @punch = Punch.new
  end

  def edit
    @punch = Punch.find(params[:id]).decorate
  end

  def create
    @punch = Punch.new(punch_params)
    @punch.user_id = current_user.id

    if @punch.save
      redirect_to punches_path, notice: I18n.t(:notice, scope: "flash.actions.create", resource_name: "Punch")
    else
      flash_errors('create')
      render :new
    end
  end

  def bulk_create
    punches_params = params.require(:punches_calendar_form).permit(:project_id, :from1, :from2, :to1, :to2, days: [])

    @punches = Punches::CalendarForm.new(punches_params)
    @punches.validate
    @punches_of_day = current_user.punches.group_by(&:date)
    @current_month_by_weeks = (Date.current.beginning_of_month.beginning_of_week..Date.current.end_of_month.end_of_week).group_by do |date|
      date.strftime("%U")
    end


    render :calendar
    # @punch = Punch.new(punch_params)
    # @punch.user_id = current_user.id

    # if @punch.save
    #   redirect_to punches_path, notice: I18n.t(:notice, scope: "flash.actions.create", resource_name: "Punch")
    # else
    #   flash_errors('create')
    #   render :new
    # end
  end

  def update
    @punch = scopped_punches.find params[:id]
    @punch.attributes = punch_params

    if @punch.save
      redirect_to punches_path, notice: I18n.t(:notice, scope: "flash.actions.update", resource_name: "Punch")
    else
      flash_errors('update')
      render :new
    end
  end

  def calendar
    @selected_month = params[:month].present? && params[:year].present? ? "#{params[:year]}/#{params[:month]}/1".to_date : Date.current.beginning_of_month

    @punches = Punches::CalendarForm.new
    @punches_of_day = current_user.punches.group_by(&:date)
    @current_month_by_weeks = (@selected_month.beginning_of_week..@selected_month.end_of_month.end_of_week).group_by do |date|
      date.strftime("%U")
    end
  end

  def destroy
    punch = Punch.find(params[:id])
    punch.destroy
    redirect_to root_path, notice: I18n.t(:notice, scope: "flash.actions.destroy", resource_name: "Punch")
  end

  private

  def flash_errors(scope)
    flash.now[:alert] = "#{alert_message(scope)} #{error_message}"
  end

  def alert_message(scope)
    I18n.t(:alert, scope: "flash.actions.#{scope}", resource_name: "Punch")
  end

  def errors
    @punch.errors.full_messages.join('. ')
  end

  def error_message
    I18n.t(:errors, scope: "flash", errors: errors)
  end

  def punch_params
    params.require(:punch).permit(:from_time, :to_time, :when_day, :project_id, :attachment,
      :remove_attachment, :comment, :extra_hour)
  end

  def user_projects
    @projects = Project.active.order(:name)
  end

  def scopped_punches
    current_user.punches
  end
end
