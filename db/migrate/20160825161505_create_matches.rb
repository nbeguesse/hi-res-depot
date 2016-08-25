class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.references :image, index: true, foreign_key: true
      t.references :matched_image, index: true

      t.timestamps null: false
    end

    add_foreign_key :matches, :images, column: :matched_image_id
    add_index :matches, [:image_id, :matched_image_id], unique: true
  end
end
