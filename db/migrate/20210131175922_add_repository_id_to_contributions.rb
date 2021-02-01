class AddRepositoryIdToContributions < ActiveRecord::Migration[6.0]
  def change
    add_reference :contributions, :repository, foreign_key: true
  end
end
