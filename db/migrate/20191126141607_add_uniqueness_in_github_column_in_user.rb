class AddUniquenessInGithubColumnInUser < ActiveRecord::Migration[5.2]
  def change
    add_index :users, :github, unique: true
  end
end
