class AddReviewedByAtAndByToContributions < ActiveRecord::Migration[6.1]
  def change
    add_column :contributions, :reviewed_by, :string
    add_column :contributions, :reviewed_at, :datetime
  end
end
