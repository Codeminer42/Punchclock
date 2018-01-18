class AddCompanyIdToComments < ActiveRecord::Migration[4.2]
  def change
    add_reference :comments, :company, index: true
  end
end
