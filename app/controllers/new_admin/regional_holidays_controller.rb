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

    def new
      @regional_holiday = RegionalHoliday.new
    end

    def create
      @regional_holiday = RegionalHoliday.new(regional_holiday_params)

      if @regional_holiday.save
        redirect_to new_admin_regional_holidays_path,
                    I18n.t(:notice, scope: "flash.actions.create", resource_name: RegionalHoliday.model_name.human)
      else
        flash.now[:alert] = @regional_holiday.errors.full_messages.to_sentence
        render :new
      end
    end

    private

    def filter_params
      params.permit(
        :regional_holiday_id,
        :month,
        city_ids: []
      ).to_h
    end

    def regional_holiday_params
      params.require(:regional_holiday).permit(:name, :day, :month, :city_ids)
    end

    def load_cities_with_holidays
      @cities_with_holidays = City.with_holidays
    end
  end
end
