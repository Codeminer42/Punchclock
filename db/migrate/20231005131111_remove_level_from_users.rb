class RemoveLevelFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :level, :string
  end
end
