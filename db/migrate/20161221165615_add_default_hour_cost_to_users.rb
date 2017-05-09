class AddDefaultHourCostToUsers < ActiveRecord::Migration
  def change
    change_column :users, :hour_cost, null: false, default: 0
  end
end
