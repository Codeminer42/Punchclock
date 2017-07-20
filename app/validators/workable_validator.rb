class WorkableValidator < ActiveModel::Validator
  def validate(model)
    @model = model
    @model.errors.add(:from, 'you can only select workdays') if workable_day?
  end

  private

  def weekend?
    @model.from.saturday? || @model.from.sunday?
  end

  def regional_holiday?
    punch_date = format_date(@model.from)
    @model.user.regional_holidays.any? do |holiday|
      same_day?(punch_date, format_date(holiday))
    end
  end

  def workable_day?
    !@model.user.allow_overtime &&
    (weekend? || @model.from.to_date.holiday?(:br) || regional_holiday?)
  end

  def same_day?(date, holiday)
    date == holiday
  end

  def format_date(date)
    [date.month, date.day]
  end
end
