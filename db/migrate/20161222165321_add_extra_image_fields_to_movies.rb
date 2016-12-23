class AddExtraImageFieldsToMovies < ActiveRecord::Migration[5.0]
  def change
    add_column :movies, :image_content_type, :string
    add_column :movies, :image_file_size, :integer
    add_column :movies, :image_updated_at, :datetime
  end
end
