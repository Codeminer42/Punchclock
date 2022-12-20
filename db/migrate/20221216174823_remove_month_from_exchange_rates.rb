class RemoveMonthFromExchangeRates < ActiveRecord::Migration[7.0]
  def up
    ExchangeRate.where(month: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]).delete_all

    remove_index :exchange_rates, column: %w[month year currency]
    remove_column :exchange_rates, :month, :integer
    add_index :exchange_rates, %w[year currency], unique: true
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
