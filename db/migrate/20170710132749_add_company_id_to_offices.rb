class AddCompanyIdToOffices < ActiveRecord::Migration
  def change
    change_table :offices do |t|
      t.references :company, index: true
    end
  end
end
