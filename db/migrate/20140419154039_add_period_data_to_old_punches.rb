class AddPeriodDataToOldPunches < ActiveRecord::Migration
  def up
    Punch.wrongs.fix_all
  end

  def down
    Punch.update_all period_id: nil
    Period.delete_all
  end
end
