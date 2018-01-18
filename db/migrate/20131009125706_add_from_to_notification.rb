class AddFromToNotification < ActiveRecord::Migration[4.2]
  def change
    add_column :notifications, :from_user_id, :integer
  end
end
