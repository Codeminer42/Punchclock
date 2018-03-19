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
    @model.errors.add(:from, 'you can only select workdays')
  end

  def weekend?
    @model.from.saturday? || @model.from.sunday?
  end

  def holiday?
    national_holiday? || regional_holiday?
  end

  def national_holiday?
    # p @model.from.to_date
    @model.from.to_date.holiday?(:br)
  end

  def regional_holiday?
   punch_date = format_date(@model.from)
   # p punch_date
   @model.user.regional_holidays.present? do |holiday|
     same_day?(punch_date, format_date(holiday))
   end
  end

  def same_day?(date, holiday)
    date == holiday
  end

  def format_date(date)
    [date.month, date.day]
  end

  def can_user_overtime?
    @model.user.allow_overtime
  end
end
