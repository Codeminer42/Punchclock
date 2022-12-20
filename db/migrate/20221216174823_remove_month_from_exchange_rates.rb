class RemoveMonthFromExchangeRates < ActiveRecord::Migration[7.0]
  def up
    remove_index :exchange_rates, column: %w[month year currency]
    remove_column :exchange_rates, :month, :integer
    add_index :exchange_rates, %w[year currency], unique: true
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
