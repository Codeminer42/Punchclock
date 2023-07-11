class RenameSkillsUsersToUsersSkills < ActiveRecord::Migration[7.0]
  def change
    rename_table(:skills_users, :user_skills)
  end
end
