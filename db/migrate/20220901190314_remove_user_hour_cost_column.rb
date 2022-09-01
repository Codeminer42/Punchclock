class RemoveUserHourCostColumn < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :hour_cost
  end
end
