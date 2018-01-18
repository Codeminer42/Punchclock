class AddCompanyIdToAdminUsers < ActiveRecord::Migration[4.2]
  def change
    change_table :admin_users do |t|
      t.references :company, index: true
    end
  end
end
