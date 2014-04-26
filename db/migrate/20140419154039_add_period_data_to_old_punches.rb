class AddPeriodDataToOldPunches < ActiveRecord::Migration
  def up
    Company.all.each do |company|
      company.punches.wrongs.fix_all
    end
  end

  def down
    Punch.update_all period_id: nil
    Period.delete_all
  end
end
