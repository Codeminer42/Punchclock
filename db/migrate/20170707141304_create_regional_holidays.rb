class CreateRegionalHolidays < ActiveRecord::Migration[4.2]
  def change
    create_table :regional_holidays do |t|
      t.string :name
      t.integer :day
      t.integer :month

      t.timestamps null: false
    end
  end
end
