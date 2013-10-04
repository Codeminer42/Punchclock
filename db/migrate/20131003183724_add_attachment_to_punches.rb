class AddAttachmentToPunches < ActiveRecord::Migration
  def change
    add_column :punches, :attachment, :string
  end
end
