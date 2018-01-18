class AddAllowOvertimeToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :allow_overtime, :boolean, default: false
  end
end
