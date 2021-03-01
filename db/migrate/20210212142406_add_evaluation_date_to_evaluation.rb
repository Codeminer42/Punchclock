class AddEvaluationDateToEvaluation < ActiveRecord::Migration[6.0]
  def change
    add_column :evaluations, :evaluation_date, :date
  end
end
