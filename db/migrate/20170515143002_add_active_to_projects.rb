class AddActiveToProjects < ActiveRecord::Migration[4.2]
  def change
    add_column :projects, :active, :boolean, default: true
  end
end
