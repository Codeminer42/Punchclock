class AddOngoingToAllocation < ActiveRecord::Migration[7.0]
  def change
    add_column :allocations, :ongoing, :boolean, { default: false }
  end
end
