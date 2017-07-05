class AddOfficeIdToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :office, index: true, foreign_key: true
  end
end
