class CreateJoinTable < ActiveRecord::Migration[4.2]
  def change
    create_join_table :offices, :regional_holidays do |t|
      t.index [:office_id, :regional_holiday_id], name: 'index_offices_on_regional_holidays'
      t.index [:regional_holiday_id, :office_id], name: 'index_regional_holidays_on_offices'
    end
  end
end
