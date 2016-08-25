class AddFileToImages < ActiveRecord::Migration
  def change
    add_column :images, :file_file_name, :string
    add_column :images, :file_content_type, :string
    add_column :images, :file_file_size, :integer
    add_column :images, :file_updated_at, :timestamp
    add_column :images, :file_original_width, :integer
    add_column :images, :file_original_height, :integer
  end
end
