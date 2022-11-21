class RenameManagerToCommercionFromVatation < ActiveRecord::Migration[7.0]
  def change
    rename_column :vacations, :project_manager_approver_id, :commercial_approver_id
  end
end
