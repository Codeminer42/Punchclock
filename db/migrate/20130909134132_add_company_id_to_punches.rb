class AddCompanyIdToPunches < ActiveRecord::Migration[4.2]
  def change
    add_reference :punches, :company, index: true
  end
end
