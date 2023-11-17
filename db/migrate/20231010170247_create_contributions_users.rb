class CreateContributionsUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :contributions_users do |t|
      t.references :contribution
      t.references :user

      t.timestamps
    end
  end
end
