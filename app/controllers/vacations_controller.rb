class VacationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @vacations = scoped_vacations
  end

  def show
    @vacation = scoped_vacations.find(params[:id])
  end

  def new
    @vacation = Vacation.new
  end

  def create
    @vacation = scoped_vacations.new(vacation_params)

    if @vacation.save
      redirect_to vacations_path, notice: I18n.t(:notice, scope: "flash.vacation.create")
    else
      flash_errors('create')
      render :new
    end
  end

  def cancel
    vacation_to_cancel = scoped_vacations.find(params[:id])

    if vacation_to_cancel.pending?
      vacation_to_cancel.update!(status: :cancelled)
      redirect_to vacations_path, notice: I18n.t(:notice, scope: "flash.vacation.cancel")
    else
      redirect_to vacations_path, alert: I18n.t(:alert, scope: "flash.vacation.cancel")
    end
  end

  private

  def scoped_vacations
    current_user.vacations
  end

  def vacation_params
    params.require(:vacation).permit(:start_date, :end_date)
  end

  def flash_errors(scope)
    flash.now[:alert] = "#{alert_message(scope)} #{error_message}"
  end

  def alert_message(scope)
    I18n.t(:alert, scope: "flash.actions.#{scope}", resource_name: "Vacation")
  end

  def errors
    @vacation.errors.full_messages.join('. ')
  end

  def error_message
    I18n.t(:errors, scope: "flash", errors: errors)
  end
end
