class AddUniqueIndexToCities < ActiveRecord::Migration[7.0]
  def change
    add_index :cities, :name, unique: true
    add_index :states, :code, unique: true
  end
end
