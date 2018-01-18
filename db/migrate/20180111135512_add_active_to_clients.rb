class AddActiveToClients < ActiveRecord::Migration[4.2]
  def change
    add_column :clients, :active, :boolean, default: true
  end
end
