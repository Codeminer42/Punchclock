class AddCompanyIdToComments < ActiveRecord::Migration
  def change
    add_reference :comments, :company, index: true
  end
end
