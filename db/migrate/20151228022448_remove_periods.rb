class RemovePeriods < ActiveRecord::Migration
  def change
    remove_column :punches, :period_id
    drop_table :periods
  end
end
