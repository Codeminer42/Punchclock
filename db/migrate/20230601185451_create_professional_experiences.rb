class CreateProfessionalExperiences < ActiveRecord::Migration[7.0]
  def change
    create_table :professional_experiences do |t|
      t.string :company
      t.string :position
      t.text :description
      t.string :responsibilities
      t.date :start_date
      t.date :end_date
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
