class AddColumnsToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      ## Database authenticatable
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      add_index :users, :reset_password_token, :unique => true
    end
  end
end
