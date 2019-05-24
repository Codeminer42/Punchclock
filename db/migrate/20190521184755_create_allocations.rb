# frozen_string_literal: true

class CreateAllocations < ActiveRecord::Migration[5.2]
  def change
    create_table :allocations do |t|
      t.references :user, foreign_key: true, null: false
      t.references :project, foreign_key: true, null: false
      t.date :start_at, null: false
      t.date :end_at
      t.references :company, index: true, foreign_key: true

      t.timestamps
    end
  end
end
