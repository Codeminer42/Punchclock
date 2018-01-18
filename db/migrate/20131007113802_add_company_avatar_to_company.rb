class AddCompanyAvatarToCompany < ActiveRecord::Migration[4.2]
  def change
    add_column :companies, :avatar, :string
  end
end
