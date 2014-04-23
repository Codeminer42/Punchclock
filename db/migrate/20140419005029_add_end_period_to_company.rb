class AddEndPeriodToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :end_period, :integer
  end
end
