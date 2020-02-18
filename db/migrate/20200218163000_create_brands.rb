class CreateBrands < ActiveRecord::Migration[6.0]
  def change
    create_table :brands do |t|
      t.string :name
      t.string :prefix_name
      t.string :slug
      t.boolean :is_active, default: true
      t.boolean :is_deleted, default: false

      t.timestamps
    end
  end
end
