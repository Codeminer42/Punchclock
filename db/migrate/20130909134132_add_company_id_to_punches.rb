class AddCompanyIdToPunches < ActiveRecord::Migration
  def change
    add_reference :punches, :company, index: true
  end
end
