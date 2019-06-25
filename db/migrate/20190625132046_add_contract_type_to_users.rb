class AddContractTypeToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :contract_type, :integer
  end
end
