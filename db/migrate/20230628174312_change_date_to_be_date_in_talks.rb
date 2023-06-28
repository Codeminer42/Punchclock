class ChangeDateToBeDateInTalks < ActiveRecord::Migration[7.0]
  def change
    change_column :talks, :date, :date
  end
end
