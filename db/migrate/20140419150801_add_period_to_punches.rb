class AddPeriodToPunches < ActiveRecord::Migration
  def change
    add_reference :punches, :period, index: true
  end
end
