class RevenueProjectorService
  def self.data_from_allocation(allocation)
    new.revenue_from_allocation(allocation)
  end

  def revenue_from_allocation(allocation)
    month = allocation.start_at.beginning_of_month
    beginning_of_end_date_month = allocation.end_at.beginning_of_month

    result = []
    while month <= beginning_of_end_date_month
      result << allocation_month_data(allocation, month)
      month = month.next_month
    end

    result
  end

  def self.data_from_project(project)
    new.revenue_from_project(project)
  end

  def revenue_from_project(project, period = nil)
    result = {}

    allocations = project.allocations
    allocations = allocations.in_period(period[0], period[1]) if period

    allocations.each do |allocation|
      allocation_revenue = revenue_from_allocation(allocation)

      allocation_revenue.each do |data|
        year = data[:year]
        year_data = result[year] || {}

        month = data[:month]
        month_revenue = year_data[month] || Money.new(0)

        year_data[month] = month_revenue + data[:revenue]
        result[year] = year_data
      end
    end

    result
  end

  def self.revenue_from_year(year)
    new.revenue_from_year(year)
  end

  def revenue_from_year(year)
    beginning_of_year = Date.ordinal(year)
    end_of_year = Date.ordinal(year, -1)

    result = []
    projects = active_projects_on_period(beginning_of_year, end_of_year)

    projects.each do |project|
      revenue = revenue_from_project(project, [beginning_of_year, end_of_year])

      result << {
        project: project,
        revenue: revenue[year]
      }
    end

    result
  end

  private

  def allocation_month_data(allocation, beginning_of_month)
    end_of_month = beginning_of_month.end_of_month

    working_days = if allocation.start_at.beginning_of_month == beginning_of_month
                     calculate_weekdays(allocation.start_at, end_of_month)
                   elsif allocation.end_at.beginning_of_month == beginning_of_month
                     calculate_weekdays(beginning_of_month, allocation.end_at)
                   else
                     calculate_weekdays(beginning_of_month, end_of_month)
                   end

    {
      month: beginning_of_month.month,
      year: beginning_of_month.year,
      working_days: working_days,
      revenue: calculate_revenue(working_days, allocation.hourly_rate_cents)
    }
  end

  def calculate_weekdays(start_date, end_date)
    (start_date..end_date).reject(&:on_weekend?).count
  end

  def calculate_revenue(working_days, hourly_rate_cents)
    Money.new(working_days * 8 * hourly_rate_cents)
  end

  def active_projects_on_period(beginning_date, end_date)
    projects_ids_rel = Allocation
      .in_period(beginning_date, end_date)
      .select(:project_id)

    Project.where(id: projects_ids_rel).distinct
  end
end
