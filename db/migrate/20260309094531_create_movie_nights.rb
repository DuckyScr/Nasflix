class CreateMovieNights < ActiveRecord::Migration[8.1]
  def change
    create_table :movie_nights do |t|
      t.references :movie, null: false, foreign_key: true
      t.references :host, null: false, foreign_key: { to_table: :users }
      t.datetime :scheduled_at
      t.text :notes

      t.timestamps
    end
  end
end
