class AddEventPathToNotification < ActiveRecord::Migration
  def change
    add_column :notifications, :event_path, :string
  end
end
