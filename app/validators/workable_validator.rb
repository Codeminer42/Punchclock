class WorkableValidator < ActiveModel::Validator
  def validate(model)
    @model = model
    check_for_errors!
  end

  private

  def check_for_errors!
    cant_work! if (weekend? || holiday?) && !can_user_overtime?
  end

  def cant_work!
    @model.errors.add(:when_day, :must_be_workday)
  end

  def weekend?
    @model.from.saturday? || @model.from.sunday?
  end

  def holiday?
    national_holiday? || regional_holiday?
  end

  def national_holiday?
    @model.from.to_date.holiday?(:br)
  end

  def regional_holiday?
    user_has_regional_holidays? && punch_on_a_regional_holiday?(@model.from)
  end

  def user_has_regional_holidays?
    !@model.user.office_regional_holidays.nil?
  end

  def punch_on_a_regional_holiday?(punch_date)
    user_holidays.include? format_date(punch_date)
  end

  def user_holidays
    @model.user.office_regional_holidays.map { |holiday| format_date(holiday) }
  end

  def format_date(date)
    [date.month, date.day]
  end

  def can_user_overtime?
    @model.user.allow_overtime
  end
end
