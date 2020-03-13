class AddArchiveToTask < ActiveRecord::Migration[6.0]
  def change
    add_column :tasks, :archived, :boolean, default: false
  end
end
