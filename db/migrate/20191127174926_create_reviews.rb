class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.integer :reviewer_id, foreign_key: true
      t.references :contribution, index: true
      t.integer :state, null: false
      t.datetime :created_at, null: false
    end
  end
end
