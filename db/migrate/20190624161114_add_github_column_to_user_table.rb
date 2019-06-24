class AddGithubColumnToUserTable < ActiveRecord::Migration[5.2]
  def up
    add_column :users, :github, :string
  end

  def down
    remove_column :users, :github, :string
  end
end
