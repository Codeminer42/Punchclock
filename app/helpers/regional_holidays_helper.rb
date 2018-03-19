module RegionalHolidaysHelper
  def parameterize_holidays(holidays)
    holidays.map { |x| [x.month, x.day] } unless holidays.nil?
  end
end
