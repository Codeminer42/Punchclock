class RemoveLabelFromPeriod < ActiveRecord::Migration
  def change
   remove_column :periods, :label, :string
  end
end
