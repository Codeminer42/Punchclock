module RegionalHolidaysHelper
  def parameterize_holidays(holidays)
    holidays.map { |holiday| [holiday.month, holiday.day] } unless holidays.nil?
  end
end
