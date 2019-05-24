# frozen_string_literal: true

class CreateQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :questions do |t|
      t.references :questionnaire, foreign_key: true
      t.string :title
      t.integer :kind
      t.string :answer_options, array: true, default: []

      t.timestamps
    end
  end
end
