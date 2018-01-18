class RemovePeriods < ActiveRecord::Migration[4.2]
  def change
    remove_column :punches, :period_id
    drop_table :periods
  end
end
