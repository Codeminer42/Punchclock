# frozen_string_literal: true

class RevenueForecastPresenter
  def initialize(year)
    @forecasts = RevenueProjectorService.revenue_from_year(year)
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
    allocation_with_oldest_start_date = Allocation.order(:start_at).first
    allocation_with_newest_end_date = Allocation.order(end_at: :desc).first

    (allocation_with_oldest_start_date.start_at.year..allocation_with_newest_end_date.end_at.year)
  end

  private

  def month_name(number)
    Date::MONTHNAMES[number]
  end

  def month_forecasts(month_number)
    @forecasts.map do |forecast|
      value = forecast[:revenue][month_number]
      value ? helpers.humanized_money_with_symbol(value) : '-'
    end
  end

  def month_total(month_number)
    total = Money.new(0)

    @forecasts.each do |forecast|
      total += forecast[:revenue][month_number] || 0
    end

    helpers.humanized_money_with_symbol(total)
  end

  def helpers
    ActionController::Base.helpers
  end
end
