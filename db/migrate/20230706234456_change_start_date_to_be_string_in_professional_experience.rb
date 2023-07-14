class ChangeStartDateToBeStringInProfessionalExperience < ActiveRecord::Migration[7.0]
  def change
    change_column :professional_experiences, :start_date, :string
  end
end
