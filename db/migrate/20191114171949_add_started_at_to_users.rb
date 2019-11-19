class AddStartedAtToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :started_at, :date
  end
end
