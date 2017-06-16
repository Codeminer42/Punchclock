class AddExtraHourToPunches < ActiveRecord::Migration
  def change
    add_column :punches, :extra_hour, :string
  end
end
