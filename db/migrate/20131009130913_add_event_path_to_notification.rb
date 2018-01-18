class AddEventPathToNotification < ActiveRecord::Migration[4.2]
  def change
    add_column :notifications, :event_path, :string
  end
end
