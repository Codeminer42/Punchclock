class CreateEducationExperiences < ActiveRecord::Migration[7.0]
  def change
    create_table :education_experiences do |t|
      t.string :institution
      t.string :course
      t.date :start_date
      t.date :end_date
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
