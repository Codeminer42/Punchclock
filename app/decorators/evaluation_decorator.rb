class EvaluationDecorator < ApplicationDecorator
  delegate_all

  def evaluation_date
    object.evaluation_date.strftime('%Y-%m-%d')
  end
end
