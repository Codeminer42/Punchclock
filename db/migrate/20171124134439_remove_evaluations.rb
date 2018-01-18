class RemoveEvaluations < ActiveRecord::Migration[4.2]
  def change
    drop_table :evaluations
  end
end
