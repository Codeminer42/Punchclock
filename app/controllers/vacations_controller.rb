class VacationsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:deny, :approve]

  before_action :authenticate_user!, except: [:deny, :approve, :destroy]

  def index
    @vacations = scoped_vacations
  end

  def approve
    vacation_to_approve = Vacation.find(params[:id])

    if vacation_to_approve.pending?
      vacation_to_approve.update!(status: :approved)

      VacationMailer.admin_vacation_approved(vacation_to_approve).deliver_later
      VacationMailer.notify_vacation_approved(vacation_to_approve).deliver_later
    end

    head :no_content
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
      VacationMailer.notify_vacation_request(@vacation, User.vacation_managers.map(&:email)).deliver_later

      redirect_to vacations_path, notice: I18n.t(:notice, scope: "flash.vacation.create")
    else
      flash_errors('create')
      render :new
    end
  end

  def destroy
    current_user ? cancel(params) : external_deny(params)
  end

  private

  def external_deny(params)
    vacation_to_deny = Vacation.find(params[:id])

    if vacation_to_deny.pending?
      vacation_to_deny.update!(status: :denied)
      VacationMailer.notify_vacation_denied(vacation_to_deny).deliver_later
    end

    head :no_content
  end

  def cancel(params)
    vacation_to_cancel = scoped_vacations.find(params[:id])

    if vacation_to_cancel.pending?
      vacation_to_cancel.update!(status: :cancelled)
      VacationMailer.notify_vacation_cancelled(vacation_to_cancel).deliver_later
      redirect_to vacations_path, notice: I18n.t(:notice, scope: "flash.vacation.cancel")
    else
      redirect_to vacations_path, alert: I18n.t(:alert, scope: "flash.vacation.cancel")
    end
  end

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
    I18n.t(:alert, scope: [:flash, :actions, scope], resource_name: "Vacation")
  end

  def errors
    @vacation.errors.full_messages.join('. ')
  end

  def error_message
    I18n.t(:errors, scope: :flash, errors: errors)
  end
end
