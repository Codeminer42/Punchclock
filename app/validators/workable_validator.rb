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
    @model.from.to_date.holiday?(:br)
  end

  def regional_holiday?
    return false if user_haves_no_regional_holidays?
    is_today_a_regional_holiday?
  end

  def user_haves_no_regional_holidays?
    @model.user.regional_holidays.nil?
  end

  def is_today_a_regional_holiday?
    @model.user.regional_holidays.map do |holiday|
      format_date(holiday)
    end.include? format_date(@model.from)
  end

  def format_date(date)
    [date.month, date.day]
  end

  def can_user_overtime?
    @model.user.allow_overtime
  end
end
