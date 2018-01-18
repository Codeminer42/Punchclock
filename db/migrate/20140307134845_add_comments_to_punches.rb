class AddCommentsToPunches < ActiveRecord::Migration[4.2]
  def self.up
    add_column :punches, :comment, :text
  end

  def self.down
    remove_column :punches, :comment
  end
end
