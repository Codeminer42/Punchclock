class CreateCitiesRegionalHolidays < ActiveRecord::Migration[7.0]
  def change
    create_join_table :cities, :regional_holidays do |t|
      t.index [:city_id, :regional_holiday_id], name: 'index_cities_on_regional_holidays', unique: true
      t.index [:regional_holiday_id, :city_id], name: 'index_regional_holidays_on_cities', unique: true
    end
  end
end
