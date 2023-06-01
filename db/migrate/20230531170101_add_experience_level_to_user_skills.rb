class AddExperienceLevelToUserSkills < ActiveRecord::Migration[7.0]
  def change
    add_column :user_skills, :experience_level, :string
  end
end
