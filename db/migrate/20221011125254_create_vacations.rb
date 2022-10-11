class CreateVacations < ActiveRecord::Migration[7.0]
  PENDING_STATUS = 0

  def change
    create_table :vacations do |t|
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.integer :status, default: PENDING_STATUS
      t.references :user, null: false, foreign_key: true
      t.references :commercial_approver, foreign_key: { to_table: :users }
      t.references :administrative_approver, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
