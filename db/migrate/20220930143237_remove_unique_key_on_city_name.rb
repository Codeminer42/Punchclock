class RemoveUniqueKeyOnCityName < ActiveRecord::Migration[7.0]
  def up
    remove_index :cities, :name
  end

  def down
    add_index :cities, :name, unique: true
  end
end
