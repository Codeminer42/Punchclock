class CreateOffices < ActiveRecord::Migration
  def change
    create_table :offices do |t|
      t.string :city

      t.timestamps null: false
    end
  end
end
