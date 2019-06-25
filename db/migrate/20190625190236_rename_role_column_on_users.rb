class RenameRoleColumnOnUsers < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :role, :level
  end
end
