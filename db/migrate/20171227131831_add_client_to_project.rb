class AddClientToProject < ActiveRecord::Migration[4.2]
  def change
    add_reference :projects, :client, index: true
  end
end
