class AddRejectedReasonToContribution < ActiveRecord::Migration[7.0]
  def change
    add_column :contributions, :rejected_reason, :integer
  end
end
