class AddIsSuperToAdminUsers < ActiveRecord::Migration
  def change
    change_table :admin_users do |t|
      t.boolean :is_super
    end
  end
end
