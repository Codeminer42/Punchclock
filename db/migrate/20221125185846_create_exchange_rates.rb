class CreateExchangeRates < ActiveRecord::Migration[7.0]
  def change
    create_table :exchange_rates do |t|
      t.integer :month, null: false
      t.integer :year, null: false
      t.string :currency, null: false
      t.decimal :rate, null: false

      t.timestamps
      t.index %i[month year currency], unique: true
    end
  end
end
