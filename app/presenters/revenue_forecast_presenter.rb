# frozen_string_literal: true

class RevenueForecastPresenter
  # Since we started using Punch to control allocations on Sept/2022,
  # forecasts for dates before Sept/2022 are incomplete. For this reason, we
  # should only show forecasts from 2022 and beyond
  REVENUE_FORECAST_START_YEAR = 2022

  def initialize(year)
    @forecasts = RevenueForecastService.year_forecast(year)
  end

  def projects
    @forecasts.map { |i| i[:project] }
  end

  def months(&block)
    (1..12).each do |month_number|
      block.call(
        month_name(month_number),
        month_forecasts(month_number),
        month_total(month_number)
      )
    end
  end

  def self.years_range
    allocation_with_newest_end_date = Allocation.order(end_at: :desc).first

    (REVENUE_FORECAST_START_YEAR..allocation_with_newest_end_date.end_at.year)
  end

  private

  def month_name(number)
    Date::MONTHNAMES[number]
  end

  def month_forecasts(month_number)
    @forecasts.map do |forecast|
      value = forecast[:forecast][month_number]
      value ? helpers.humanized_money_with_symbol(value) : '-'
    end
  end

  def month_total(month_number)
    total = Money.new(0)

    @forecasts.each do |forecast|
      total += forecast[:forecast][month_number] || 0
    end

    helpers.humanized_money_with_symbol(total)
  end

  def helpers
    ActionController::Base.helpers
  end
end
