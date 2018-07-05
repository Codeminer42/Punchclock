class AddExtraHourBooleanToPunches < ActiveRecord::Migration[5.1]
  def change
    add_column :punches, :extra_hour, :boolean, default: false, null: false
  end
end
