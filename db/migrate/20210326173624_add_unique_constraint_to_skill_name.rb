class AddUniqueConstraintToSkillName < ActiveRecord::Migration[6.0]
  def change
    add_index(:skills, [:title, :company_id], unique: true)
  end
end
