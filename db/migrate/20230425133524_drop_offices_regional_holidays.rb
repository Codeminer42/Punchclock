class DropOfficesRegionalHolidays < ActiveRecord::Migration[7.0]
  def up
    drop_table :offices_regional_holidays, if_exists: true
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
