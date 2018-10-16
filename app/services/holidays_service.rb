class HolidaysService
  def self.from_office(office)
    office.nil? ? new.nationals : new(office).from_office
  end

  def self.nationals
    new.nationals
  end

  def initialize(office = nil)
    @office = office
  end

  def from_office
    nationals.concat(regional_holidays)
  end

  def nationals
    from = 1.year.ago.to_date
    to = DateTime.current
    Holidays.between(from, to, :br, :informal).map { |holiday| format_holidays(holiday[:date]) }
  end

  private
  def regional_holidays
    Array(office.regional_holidays).map(&method(:format_holidays))
  end

  def format_holidays(holiday)
    { month: holiday.month, day: holiday.day }
  end

  attr_reader :office
end
