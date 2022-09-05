class AddRolesToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :roles, :string, array: true, default: [Roles::NORMAL]
  end
end
