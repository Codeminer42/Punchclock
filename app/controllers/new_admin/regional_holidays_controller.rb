# frozen_string_literal: true

module NewAdmin
  class RegionalHolidaysController < ApplicationController
    layout 'new_admin'

    before_action :load_cities_with_holidays, only: :index

    def index
      @regional_holidays = RegionalHolidaysQuery.new(**filter_params).call.decorate
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
      @cities_with_holidays = City.joins(:regional_holidays).distinct.order('cities.name ASC')
    end
  end
end
