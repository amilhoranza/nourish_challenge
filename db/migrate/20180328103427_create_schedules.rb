class CreateSchedules < ActiveRecord::Migration[5.0]
  def change
    create_table :schedules do |t|
      t.datetime :starting_on
      t.datetime :ending_on
      t.string :note
      t.integer :interval, default: 1
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
