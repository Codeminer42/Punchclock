# frozen_string_literal: true

module NewAdmin
  class RegionalHolidaysController < ApplicationController
    layout 'new_admin'

    before_action :load_cities_with_holidays, only: :index

    def index
      @regional_holidays = RegionalHolidaysQuery.new(**filter_params).call.decorate
    end

    def show
      @regional_holiday = RegionalHoliday.find(params[:id])
    end

    private

    def filter_params
      params.permit(
        :regional_holiday_id,
        :month,
        city_ids: []
      ).to_h
    end

    def load_cities_with_holidays
      @cities_with_holidays = City.with_holidays
    end
  end
end
