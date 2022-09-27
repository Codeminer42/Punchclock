class RemoveCompanyIdColumnFromDatabase < ActiveRecord::Migration[7.0]
  def change
    remove_column :allocations, :company_id
    remove_column :evaluations, :company_id
    remove_column :notes, :company_id
    remove_column :questionnaires, :company_id
    remove_column :regional_holidays, :company_id
    remove_column :skills, :company_id
    remove_column :contributions, :company_id
    remove_column :offices, :company_id
    remove_column :projects, :company_id
    remove_column :punches, :company_id
    remove_column :repositories, :company_id
    remove_column :users, :company_id
  end
end
