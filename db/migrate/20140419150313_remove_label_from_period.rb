class RemoveLabelFromPeriod < ActiveRecord::Migration[4.2]
  def change
    remove_column :periods, :label, :string
  end
end
