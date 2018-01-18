class AddExtraHourToPunches < ActiveRecord::Migration[4.2]
  def change
    add_column :punches, :extra_hour, :string
  end
end
