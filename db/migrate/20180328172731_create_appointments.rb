class CreateAppointments < ActiveRecord::Migration[5.0]
  def change
    create_table :appointments do |t|
      t.datetime :when
      t.string :note
      t.integer :status, default: 0
      t.integer :manually_edited, default: 0
      t.references :schedule

      t.timestamps
    end
  end
end
