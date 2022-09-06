class DropClients < ActiveRecord::Migration[7.0]
  def change
    drop_table :clients
    remove_column :projects, :client_id
  end
end
