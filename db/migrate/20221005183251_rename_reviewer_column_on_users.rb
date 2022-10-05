class RenameReviewerColumnOnUsers < ActiveRecord::Migration[7.0]
  def change
    rename_column :users, :reviewer_id, :mentor_id
  end
end
