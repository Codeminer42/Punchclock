class RemoveCompanyIdColumnFromDatabase < ActiveRecord::Migration[7.0]
  def change
    remove_column :allocations, :company_id
    remove_column :evaluations, :company_id
    remove_column :notes, :company_id
    remove_column :questionnaires, :company_id
    remove_column :regional_holidays, :company_id
    remove_column :skills, :company_id
  end
end
