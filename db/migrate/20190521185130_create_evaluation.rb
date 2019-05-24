# frozen_string_literal: true

class CreateEvaluation < ActiveRecord::Migration[5.2]
  def change
    create_table :evaluations do |t|
      t.references :questionnaire, foreign_key: true
      t.integer :evaluator_id
      t.integer :evaluated_id
      t.text :observation
      t.integer :score
      t.integer :english_level
      t.references :company, index: true, foreign_key: true

      t.timestamps
    end
  end
end
