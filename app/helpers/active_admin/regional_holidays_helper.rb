module ActiveAdmin::RegionalHolidaysHelper
  def offices_by_holiday(holiday)
    holiday.deprecated_cities.join(', ')
  end
end
