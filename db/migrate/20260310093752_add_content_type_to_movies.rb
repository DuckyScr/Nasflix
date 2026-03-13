class AddContentTypeToMovies < ActiveRecord::Migration[8.1]
  def change
    add_column :movies, :content_type, :string
  end
end
