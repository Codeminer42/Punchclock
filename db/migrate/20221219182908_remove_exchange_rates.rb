class RemoveExchangeRates < ActiveRecord::Migration[7.0]
  def change
    drop_table :exchange_rates
  end
end
