class CreateTalkings < ActiveRecord::Migration[7.0]
  def change
    create_table :talkings do |t|
      t.string :event_name
      t.string :talk_title
      t.datetime :date
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
