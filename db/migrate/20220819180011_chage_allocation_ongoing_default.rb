class ChageAllocationOngoingDefault < ActiveRecord::Migration[7.0]
  def change
    change_column_default :allocations, :ongoing, from: false, to: true
  end
end
