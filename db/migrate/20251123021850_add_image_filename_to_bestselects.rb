class AddImageFilenameToBestselects < ActiveRecord::Migration[8.0]
  def change
    add_column :bestselects, :image_filename, :string
  end
end
