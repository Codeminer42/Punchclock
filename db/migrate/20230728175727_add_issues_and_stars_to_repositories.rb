class AddIssuesAndStarsToRepositories < ActiveRecord::Migration[7.0]
  def change
    add_column :repositories, :issues, :integer, default: 0
    add_column :repositories, :stars, :integer, default: 0
  end
end
