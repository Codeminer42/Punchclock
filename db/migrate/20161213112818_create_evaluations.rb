class CreateEvaluations < ActiveRecord::Migration
  def change
    create_table :evaluations do |t|
      t.references :user, index: true, foreign_key: true
      t.references :reviewer, index: true
      t.text :review

      t.timestamps
    end
    add_foreign_key :evaluations, :users, column: :reviewer_id
  end
end
