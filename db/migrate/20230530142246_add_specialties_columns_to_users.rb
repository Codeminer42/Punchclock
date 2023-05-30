class AddSpecialtiesColumnsToUsers < ActiveRecord::Migration[7.0]
  def change
    change_table :users do |t|
      t.integer :frontend_level, null: true
      t.integer :backend_level, null: true
    end
  end
end
