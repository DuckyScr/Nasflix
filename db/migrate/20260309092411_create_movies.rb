class CreateMovies < ActiveRecord::Migration[8.1]
  def change
    create_table :movies do |t|
      t.string :title
      t.text :description
      t.string :genre
      t.integer :year
      t.string :director

      t.timestamps
    end
  end
end
