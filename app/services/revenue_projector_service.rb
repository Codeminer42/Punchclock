class RevenueProjectorService
  def self.data_from_allocation(allocation)
    new.from_allocation(allocation)
  end

  def from_allocation(allocation)
    month = allocation.start_at.beginning_of_month
    beginning_of_end_date_month = allocation.end_at.beginning_of_month
    result = []

    while month <= beginning_of_end_date_month
      result << allocation_month_data(allocation, month)
      month = month.next_month
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
      month: beginning_of_month.strftime('%m.%Y'),
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
end
