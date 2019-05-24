# frozen_string_literal: true

class CreateAnswers < ActiveRecord::Migration[5.2]
  def change
    create_table :answers do |t|
      t.references :evaluation, foreign_key: true
      t.references :question, foreign_key: true
      t.text :response

      t.timestamps
    end
  end
end
