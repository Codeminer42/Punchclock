class CreateContributions < ActiveRecord::Migration[5.2]
  def change
    create_table :contributions do |t|
      t.references :user, index: true, foreign_key: true
      t.references :company, index: true
      t.string :link, null: false
      t.string :state, null: false
      t.timestamps
    end

    add_index :contributions, %i[user_id link], unique: true
  end
end
