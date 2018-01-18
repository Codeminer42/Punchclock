class AddReviewerIdToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :reviewer_id, :integer
    add_index :users, :reviewer_id
    add_foreign_key :users, :users, column: :reviewer_id, primary_key: :id
  end
end
