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
    pair = ->(monthday) {[monthday.month, monthday.day]}
    @model.user.regional_holidays.any? do |holiday|
      pair.call(holiday) == pair.call(@model.from)
    end
  end

  def workable_day?
    !@model.user.allow_overtime &&
    (weekend? || @model.from.to_date.holiday?(:br) || regional_holiday?)
  end
end
