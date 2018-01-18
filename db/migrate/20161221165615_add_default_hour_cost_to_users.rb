class AddDefaultHourCostToUsers < ActiveRecord::Migration[4.2]
  def change
    change_column_default(:users, :hour_cost, 0)
    change_column_null(:users, :hour_cost, false)
  end
end
