class AddDefaultHourCostToUsers < ActiveRecord::Migration
  def change
    change_column_default(:users, :hour_cost, 0)
    change_column_null(:users, :hour_cost, false)
  end
end
