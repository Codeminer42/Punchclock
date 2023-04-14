class HolidayValidator < ActiveModel::Validator
  MINIMUM_DAYS_BEFORE_HOLIDAY = 2

  def validate(model)
    @model = model
    check_for_errors!
  end

  private

  def check_for_errors!
    unless (@model.user.office_holidays & restrict_dates).empty?
      @model.errors.add(:start_date, :close_holiday)
    end
  end

  def restrict_dates
    (@model.start_date..(@model.start_date + MINIMUM_DAYS_BEFORE_HOLIDAY.days)).to_a.map do |date|
      {day: date.day, month: date.month}
    end
  end
end
