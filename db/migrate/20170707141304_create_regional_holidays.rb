class CreateRegionalHolidays < ActiveRecord::Migration
  def change
    create_table :regional_holidays do |t|
      t.string :name
      t.integer :day
      t.integer :month

      t.timestamps null: false
    end
  end
end
