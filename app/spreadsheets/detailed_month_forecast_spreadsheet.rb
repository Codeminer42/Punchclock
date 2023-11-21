class DetailedMonthForecastSpreadsheet < DefaultSpreadsheet
  def body(allocation)
    [
      allocation[:user],
      allocation[:project],
      allocation[:hourly_rate],
      allocation[:start_date],
      allocation[:end_date],
      allocation[:worked_hours],
      allocation[:total_revenue]
    ]
  end

  def header
    [
      Allocation.human_attribute_name('user'),
      Allocation.human_attribute_name('project'),
      Allocation.human_attribute_name('hourly_rate'),
      Allocation.human_attribute_name('start_at'),
      Allocation.human_attribute_name('end_at'),
      I18n.t('allocation.worked_hours'),
      I18n.t('allocation.total_revenue')
    ]
  end
end
