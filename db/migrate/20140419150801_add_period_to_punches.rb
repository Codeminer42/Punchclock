class AddPeriodToPunches < ActiveRecord::Migration[4.2]
  def change
    add_reference :punches, :period, index: true
  end
end
