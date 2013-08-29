class AddCompanyIdToAdminUsers < ActiveRecord::Migration
  def change
    change_table :admin_users do |t|
      t.references :company, index: true
    end
  end
end
