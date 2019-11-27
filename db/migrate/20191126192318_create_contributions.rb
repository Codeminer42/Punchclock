class CreateContributions < ActiveRecord::Migration[5.2]
  def change
    create_table :contributions do |t|
      t.references :user, index: true, foreign_key: true
      t.references :office, index: true
      t.string :link
      t.string :state
      t.timestamps
    end

    add_index :contributions, %i[user_id link], unique: true
  end
end
