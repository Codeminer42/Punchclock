class AddHourCostToUsers < ActiveRecord::Migration
  def change
    add_column :users, :hour_cost, :decimal
  end
end
