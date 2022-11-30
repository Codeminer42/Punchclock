# frozen_string_literal: true

class RevenueForecastService
  WORKING_HOURS = 8

  def self.allocation_forecast(allocation)
    new.allocation_forecast(allocation)
  end

  def allocation_forecast(allocation)
    date = allocation.start_at.beginning_of_month
    beginning_of_end_date_month = allocation.end_at.beginning_of_month

    result = []
    while date <= beginning_of_end_date_month
      result << allocation_month_data(allocation, date.month, date.year)
      date = date.next_month
    end

    result
  end

  def self.project_forecast(project)
    new.project_forecast(project)
  end

  def project_forecast(project, period = nil)
    result = {}

    allocations = project.allocations
    allocations = allocations.in_period(period[0], period[1]) if period

    allocations.each do |allocation|
      allocation_forecast = allocation_forecast(allocation)

      allocation_forecast.each do |data|
        year = data[:year]
        year_data = result[year] || {}

        month = data[:month]
        month_forecast = year_data[month] || Money.new(0)

        year_data[month] = month_forecast + data[:forecast]
        result[year] = year_data
      end
    end

    result
  end

  def self.year_forecast(year)
    new.year_forecast(year)
  end

  def year_forecast(year)
    beginning_of_year = Date.ordinal(year)
    end_of_year = Date.ordinal(year, -1)

    result = []
    active_projects_on_period(beginning_of_year, end_of_year).each do |project|
      forecast = project_forecast(project, [beginning_of_year, end_of_year])

      result << { project: project, forecast: forecast[year] }
    end

    result
  end

  private

  def allocation_month_data(allocation, month, year)
    working_days = calculate_working_days(allocation, month, year)
    hourly_rate = allocation.hourly_rate
    forecast = hourly_rate * working_days * WORKING_HOURS

    unless hourly_rate.currency.iso_code == "BRL"
      exchange_rate = ExchangeRate.for_month_and_year!(month, year)
      forecast = forecast.with_currency("BRL") * exchange_rate.rate
    end

    { month:, year:, working_days:, forecast: }
  end

  def calculate_weekdays(start_date, end_date)
    (start_date..end_date).reject(&:on_weekend?).count
  end

  def same_month_and_year?(date1, date2)
    date1.month == date2.month && date1.year == date2.year
  end

  def calculate_working_days(allocation, month, year)
    start_date = allocation.start_at
    end_date = allocation.end_at
    analyzed_month = Date.new(year, month, 1)

    if same_month_and_year?(start_date, end_date)
      calculate_weekdays(start_date, end_date)
    elsif same_month_and_year?(start_date, analyzed_month)
      calculate_weekdays(start_date, analyzed_month.end_of_month)
    elsif same_month_and_year?(end_date, analyzed_month)
      calculate_weekdays(analyzed_month, end_date)
    else
      calculate_weekdays(analyzed_month, analyzed_month.end_of_month)
    end
  end

  def active_projects_on_period(beginning_date, end_date)
    projects_ids_rel = Allocation.in_period(beginning_date, end_date)
                                 .select(:project_id)

    Project.where(id: projects_ids_rel).distinct
  end
end
