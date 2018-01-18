class AddCompanyIdToUsers < ActiveRecord::Migration[4.2]
  def change
    add_reference :users, :company, index: true
  end
end
