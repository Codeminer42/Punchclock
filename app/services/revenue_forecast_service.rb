# frozen_string_literal: true

class RevenueForecastService
  WORKING_HOURS = 8

  def self.allocation_forecast(allocation)
    new.allocation_forecast(allocation)
  end

  def allocation_forecast(allocation)
    month = allocation.start_at.beginning_of_month
    beginning_of_end_date_month = allocation.end_at.beginning_of_month

    result = []
    while month <= beginning_of_end_date_month
      result << allocation_month_data(allocation, month)
      month = month.next_month
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

  def allocation_month_data(allocation, beginning_of_month)
    working_days = calculate_working_days(allocation, beginning_of_month)

    {
      month: beginning_of_month.month,
      year: beginning_of_month.year,
      working_days: working_days,
      forecast: calculate_forecast(working_days, allocation.hourly_rate, beginning_of_month)
    }
  end

  def calculate_weekdays(start_date, end_date)
    (start_date..end_date).reject(&:on_weekend?).count
  end

  def calculate_working_days(allocation, beginning_of_month)
    if allocation.start_at.beginning_of_month == allocation.end_at.beginning_of_month
      calculate_weekdays(allocation.start_at, allocation.end_at)
    elsif allocation.start_at.beginning_of_month == beginning_of_month
      calculate_weekdays(allocation.start_at, beginning_of_month.end_of_month)
    elsif allocation.end_at.beginning_of_month == beginning_of_month
      calculate_weekdays(beginning_of_month, allocation.end_at)
    else
      calculate_weekdays(beginning_of_month, beginning_of_month.end_of_month)
    end
  end

  def calculate_forecast(working_days, hourly_rate, beginning_of_month)
    exchange_rate_date = if beginning_of_month > Date.current
                           Date.current.beginning_of_month - 1
                         else
                           beginning_of_month - 1
                         end

    converted_rate = hourly_rate.exchange_to_historical('BRL', exchange_rate_date)
    converted_rate * working_days * WORKING_HOURS
  end

  def active_projects_on_period(beginning_date, end_date)
    projects_ids_rel = Allocation.in_period(beginning_date, end_date)
                                 .select(:project_id)

    Project.where(id: projects_ids_rel).distinct
  end
end
