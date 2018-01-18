class AddEndPeriodToCompany < ActiveRecord::Migration[4.2]
  def change
    add_column :companies, :end_period, :integer
  end
end
