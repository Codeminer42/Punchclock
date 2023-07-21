class AddHighlightToRepositories < ActiveRecord::Migration[7.0]
  def change
    add_column :repositories, :highlight, :boolean, default: false
  end
end
