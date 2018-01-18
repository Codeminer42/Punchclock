class AddCompanyIdToOffices < ActiveRecord::Migration[4.2]
  def change
    change_table :offices do |t|
      t.references :company, index: true
    end
  end
end
