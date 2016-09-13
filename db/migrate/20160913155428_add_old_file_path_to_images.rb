class AddOldFilePathToImages < ActiveRecord::Migration
  def change
    add_column :images, :old_file_path, :string
  end
end
