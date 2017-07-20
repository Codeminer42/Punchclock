module ActiveAdmin::RegionalHolidaysHelper
  def offices_by_holiday(holiday)
    holiday.cities.join(', ')
  end
end
