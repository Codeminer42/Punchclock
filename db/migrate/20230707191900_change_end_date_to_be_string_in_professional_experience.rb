class ChangeEndDateToBeStringInProfessionalExperience < ActiveRecord::Migration[7.0]
  def change
    change_column :professional_experiences, :end_date, :string
  end
end
