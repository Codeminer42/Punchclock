class CreateRepositories < ActiveRecord::Migration[5.2]
  def change
    create_table :repositories do |t|
      t.string :link, null: false
      t.references :company, index: true

      t.timestamps
    end

    add_index :repositories, %i[company_id link], unique: true
  end
end
