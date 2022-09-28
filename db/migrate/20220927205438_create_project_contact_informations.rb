class CreateProjectContactInformations < ActiveRecord::Migration[7.0]
  def change
    create_table :project_contact_informations do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :phone
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
