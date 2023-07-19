# frozen_string_literal: true

module NewAdmin
  class RegionalHolidaysController < ApplicationController
    layout 'new_admin'

    def index
      @regional_holidays = RegionalHoliday.all.decorate
    end
  end
end
