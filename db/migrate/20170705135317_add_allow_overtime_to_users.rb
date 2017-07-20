class AddAllowOvertimeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :allow_overtime, :boolean, default: false
  end
end
