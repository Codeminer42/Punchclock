# frozen_string_literal: true

class AddMinerCampColumnsToUser < ActiveRecord::Migration[5.2]
  def change
    change_table :users do |t|
      t.integer :occupation
      t.boolean :admin, default: false
      t.text :observation
      t.integer :specialty
    end
  end
end
