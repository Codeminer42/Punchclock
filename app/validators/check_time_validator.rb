class CheckTimeValidator < ActiveModel::Validator
  def validate(model)
    from = model.from
    to = model.to
    if from.present? && to.present?
      if to < from
        model.errors.add(:from, "can't be greater then From time")
      elsif from.to_date < to.to_date
        model.errors.add(:to, "cant't be diferente dates")
      elsif Time.now < to.to_date
        model.errors.add(:to, "can't be in the future, take you time machine and go back")
      end
    end
  end
end
