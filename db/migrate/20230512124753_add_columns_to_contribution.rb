class AddColumnsToContribution < ActiveRecord::Migration[7.0]
  def change
    add_column :contributions, :tracking, :boolean, default: false, null: false
    add_column :contributions, :notes, :text
    add_column :contributions, :pending, :string
  end
end
