class RemoveCompaniesTable < ActiveRecord::Migration[7.0]
  def change
    drop_table :companies, force: :cascade
  end
end
