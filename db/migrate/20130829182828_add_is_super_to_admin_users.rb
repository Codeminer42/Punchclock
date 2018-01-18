class AddIsSuperToAdminUsers < ActiveRecord::Migration[4.2]
  def change
    change_table :admin_users do |t|
      t.boolean :is_super
    end
  end
end
