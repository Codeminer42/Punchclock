class AddMarketToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :market, :string
  end
end
