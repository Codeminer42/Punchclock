class ChangeAllocationEndAtColumn < ActiveRecord::Migration[7.0]
  def change
    change_column :allocations, :end_at, :date, null: false
  end
end
