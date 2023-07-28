# frozen_string_literal: true

class EvaluationDecorator < Draper::Decorator
  delegate_all
  decorates_association :evaluation

  def self.collection_decorator_class
    PaginatingDecorator
  end

  def created_at
    model.created_at.to_date.to_fs(:date)
  end

  def evaluation_date
    model.evaluation_date.to_date.to_fs(:date)
  end
end
