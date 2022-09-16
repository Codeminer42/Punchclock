class AddContractCompanyCountry < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :contract_company_country, :integer
  end
end
