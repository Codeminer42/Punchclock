class RemoveIsAdminUserColumn < ActiveRecord::Migration[4.2]
  def change
    remove_column :users, :is_admin, :boolean
  end
end
