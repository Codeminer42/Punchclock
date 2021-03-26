class AddActiveToOffice < ActiveRecord::Migration[6.0]
  def change
    add_column :offices, :active, :boolean, default: true
  end
end
