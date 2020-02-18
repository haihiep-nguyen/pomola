class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :username
      t.string :name
      t.string :encrypted_password
      t.string :reset_password_token
      t.string :photo
      t.belongs_to :brand, null: false, foreign_key: true
      t.string :slug
      t.date :dob
      t.string :address
      t.boolean :is_deleted, default: false
      t.boolean :is_active, default: true

      t.timestamps
    end
  end
end
