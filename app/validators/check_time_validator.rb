class CheckTimeValidator < ActiveModel::Validator
  def validate(model)
    @model = model
    check_for_errors!
  end

  private

  def check_for_errors!
    if range?
      if negative_range?
        cant_be_great!
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

  def cant_be_great!
    @model.errors.add(:from, "can't be greater then From time")
  end

  def cant_be_different!
    @model.errors.add(:to, "cant't be different dates")
  end

  def cant_be_future!
    @model.errors.add(:to, "can't be in the future, take you time machine \
                     and go back")
  end
end
