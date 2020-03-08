class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.integer :serial, null: false
      t.string :name
      t.string :description
      t.integer :status, null: false
      t.datetime :start_at
      t.datetime :end_at
      t.datetime :total_time
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
