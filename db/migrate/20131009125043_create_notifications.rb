class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.references :user, index: true
      t.string :message
      t.boolean :read

      t.timestamps
    end
  end
end
