class CheckTimeValidator < ActiveModel::Validator
  def validate(model)
    @model = model
    check_for_errors!
  end

  private

  def check_for_errors!
    if range?
      if negative_range?
        cant_be_greater!
      elsif to_another_day?
        cant_be_different!
      elsif future?
        cant_be_future!
      end
    end
  end

  def range?
    @model.from.present? && @model.to.present?
  end

  def negative_range?
    @model.to < @model.from
  end

  def to_another_day?
    @model.from.to_date != @model.to.to_date
  end

  def future?
    @model.to.future?
  end

  def cant_be_greater!
    @model.errors.add(:from_time, :cant_be_greater)
  end

  def cant_be_different!
    @model.errors.add(:to_time, :cant_be_different)
  end

  def cant_be_future!
    @model.errors.add(:to_time, :cant_be_future)
  end
end
