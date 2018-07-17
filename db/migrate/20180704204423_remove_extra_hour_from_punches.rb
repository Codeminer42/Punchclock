class RemoveExtraHourFromPunches < ActiveRecord::Migration[5.1]
  def up
    remove_column :punches, :extra_hour
  end

  def down
    add_column :punches, :extra_hour, :string
  end
end
