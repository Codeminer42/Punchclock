class EvaluationDecorator < Draper::Decorator
  delegate_all
  decorates_association :evaluation

  def created_at
    model.created_at.to_date.to_fs(:date)
  end 
end 
