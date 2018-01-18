class CreatePunches < ActiveRecord::Migration[4.2]
  def change
    create_table :punches do |t|
      t.datetime :from
      t.datetime :to
      t.references :project, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
