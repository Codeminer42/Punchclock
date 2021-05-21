class CreateNotes < ActiveRecord::Migration[6.0]
  def change
    create_table :notes do |t|
      t.text :comment
      t.string :rate
      t.references :user, foreign_key: true
      t.references :author, foreign_key: { to_table: :users }
      t.references :company, foreign_key: true

      t.timestamps
    end
  end
end
