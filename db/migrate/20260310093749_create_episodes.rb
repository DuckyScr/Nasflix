class CreateEpisodes < ActiveRecord::Migration[8.1]
  def change
    create_table :episodes do |t|
      t.references :movie, null: false, foreign_key: true
      t.integer :season_number
      t.integer :episode_number
      t.string :title

      t.timestamps
    end
  end
end
