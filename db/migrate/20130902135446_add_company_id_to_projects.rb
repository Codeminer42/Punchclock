class AddCompanyIdToProjects < ActiveRecord::Migration
  def change
    change_table :projects do |t|
      t.references :company, index: true
    end
  end
end
