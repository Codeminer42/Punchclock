# frozen_string_literal: true

module NewAdmin
  class AllocationsController < NewAdminController
    def show
      allocation = Allocation.find(params[:id])

      @allocation_forecast = RevenueForecastService.allocation_forecast(allocation)
      @allocation = allocation.decorate

      AbilityAdmin.new(current_user).authorize! :manage, @allocation
    end

    def edit
      @allocation = Allocation.find(params[:id])
      AbilityAdmin.new(current_user).authorize! :manage, @allocation
    end

    def update
      @allocation = Allocation.find(params[:id])
      AbilityAdmin.new(current_user).authorize! :manage, @allocation

      @allocation.attributes = allocation_params

      if @allocation.save
        redirect_to new_admin_user_allocation_path(@allocation)
      else
        flash_errors('update')
        redirect_to edit_new_admin_user_allocation_path(@allocation)
      end
    end

    private

    def allocation_params
      parameters = params.require(:allocation).permit(:user_id, :project_id, :start_at, :end_at, :ongoing, :hourly_rate_cents, :hourly_rate_currency)
      parameters[:hourly_rate_cents] = to_cents(parameters[:hourly_rate_cents]) if parameters[:hourly_rate_cents].present?
      parameters
    end

    def to_cents(value)
      (value.to_f * 100).round
    end

    def flash_errors(scope)
      flash[:alert] = "#{alert_message(scope)} #{error_message}"
    end

    def errors
      @allocation.errors.full_messages.join('. ')
    end

    def alert_message(scope)
      I18n.t(:alert, scope: "flash.actions.#{scope}", resource_name: "Alocação")
    end

    def error_message
      I18n.t(:errors, scope: "flash", errors: errors)
    end
  end
end
