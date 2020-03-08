class CreateTrackingTimes < ActiveRecord::Migration[6.0]
  def change
    create_table :tracking_times do |t|
      t.belongs_to :task, null: false, foreign_key: true
      t.datetime :start_at
      t.datetime :end_at
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
