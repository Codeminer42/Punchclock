class RenameUserSkillsTable < ActiveRecord::Migration[5.2]
  def change
    rename_table(:user_skills, :skills_users)
  end
end
