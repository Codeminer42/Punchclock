class AddDefaultContractTypeToUser < ActiveRecord::Migration[5.2]
  def change
  	change_column_default(:users, :contract_type, 1)
  end
end
