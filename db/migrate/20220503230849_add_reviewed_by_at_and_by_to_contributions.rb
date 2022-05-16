class AddReviewedByAtAndByToContributions < ActiveRecord::Migration[6.1]
  def change
     add_reference :contributions, :reviewed_by, references: :users, index: true
     add_column :contributions, :reviewed_at, :datetime
  end
end
