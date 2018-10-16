class HolidaysFromOffice
  def self.perform(office)
    new(office).perform
  end

  def initialize(office)
    @office = office
  end

  def perform
    national_holidays.concat(regional_holidays)
  end

  private
  def national_holidays
    from = 1.year.ago
    to = DateTime.current
    Holidays.between(from, to, :br, :informal).map { |holiday| format_holidays(holiday[:date]) }
  end

  def regional_holidays
    Array(office.regional_holidays).map(&method(:format_holidays))
  end

  def format_holidays(holiday)
    { month: holiday.month, day: holiday.day }
  end

  attr_reader :office
end
