class RenameVacationApprovers < ActiveRecord::Migration[7.0]
  def change
    rename_column :vacations, :commercial_approver_id, :hr_approver_id
    rename_column :vacations, :administrative_approver_id, :project_manager_approver_id
  end
end
