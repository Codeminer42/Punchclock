# frozen_string_literal: true

class AddMinerCampColumnsToOffice < ActiveRecord::Migration[5.2]
  def change
    change_table :offices do |t|
      t.integer :users_count, default: 0
      t.float :score
      t.integer :head_id
    end
  end
end
