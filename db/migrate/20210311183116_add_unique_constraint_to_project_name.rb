class AddUniqueConstraintToProjectName < ActiveRecord::Migration[6.0]
  def change
    add_index(:projects, [:name, :company_id], unique: true)
  end
end
