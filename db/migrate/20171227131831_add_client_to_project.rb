class AddClientToProject < ActiveRecord::Migration
  def change
    add_reference :projects, :client, index: true
  end
end
