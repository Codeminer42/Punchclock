class AddDescriptionToRepositories < ActiveRecord::Migration[7.0]
  def change
    add_column :repositories, :description, :text
  end
end
