# frozen_string_literal: true

class CreateQuestionnaires < ActiveRecord::Migration[5.2]
  def change
    create_table :questionnaires do |t|
      t.string :title
      t.integer :kind
      t.text :description
      t.boolean :active
      t.references :company, index: true, foreign_key: true

      t.timestamps
    end
  end
end
