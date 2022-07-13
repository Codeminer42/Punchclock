class AddAuthTokenToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :auth_token, :string
    add_index :users, :auth_token, unique: true
  end
end
