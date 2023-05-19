# frozen_string_literal: true

module NewAdmin
  class AllocationsController < ApplicationController
    layout "new_admin"

    def show
      allocation = Allocation.find(params[:id])

      @allocation_forecast = RevenueForecastService.allocation_forecast(allocation)
      @allocation = allocation.decorate
    end
  end
end