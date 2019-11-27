class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.references :user, index: true, foreign_key: true
      t.references :contribution, index: true
      t.integer :state, null: false
      t.datetime :created_at, null: false
      t.timestamps
    end
  end
end
