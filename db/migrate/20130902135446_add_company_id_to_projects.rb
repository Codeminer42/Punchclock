class AddCompanyIdToProjects < ActiveRecord::Migration[4.2]
  def change
    change_table :projects do |t|
      t.references :company, index: true
    end
  end
end
