class WorkableValidator < ActiveModel::Validator
  def validate(model)
    @model = model
    check_for_errors!
  end

  private
  def check_for_errors!
    if from_and_to_are_equal?
      @model.errors.add(:from_time, :cant_be_equal)
    else 
      cant_work! if (weekend? || holiday?) && !can_user_overtime?
    end
  end

  def cant_work!
    @model.errors.add(:when_day, :must_be_workday)
  end

  def weekend?
    @model.from.saturday? || @model.from.sunday?
  end

  def holiday?
    all_holidays.include? format_date(@model.from)
  end

  def all_holidays
    @model.user.office_holidays
  end

  def format_date(date)
    {month: date.month, day: date.day}
  end

  def can_user_overtime?
    @model.user.allow_overtime
  end

  def from_and_to_are_equal?
    @model.delta == 0
  end
end
