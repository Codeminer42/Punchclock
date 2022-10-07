class AddGithubPrStatusToContributions < ActiveRecord::Migration[7.0]
  def change
    add_column :contributions, :pr_state, :string
  end
end
