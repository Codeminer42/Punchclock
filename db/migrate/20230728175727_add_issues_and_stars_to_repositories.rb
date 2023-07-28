class AddIssuesAndStarsToRepositories < ActiveRecord::Migration[7.0]
  def change
    add_column :repositories, :issues, :integer
    add_column :repositories, :stars, :integer
  end
end
