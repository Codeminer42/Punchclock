class AddTitleToNote < ActiveRecord::Migration[6.0]
  def change
    add_column :notes, :title, :string
  end
end
