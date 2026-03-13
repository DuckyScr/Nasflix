class AddKidFriendlyToMovies < ActiveRecord::Migration[8.1]
  def change
    add_column :movies, :kid_friendly, :boolean
  end
end
