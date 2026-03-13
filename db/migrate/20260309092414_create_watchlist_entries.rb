class CreateWatchlistEntries < ActiveRecord::Migration[8.1]
  def change
    create_table :watchlist_entries do |t|
      t.references :movie, null: false, foreign_key: true
      t.date :start_date
      t.date :end_date
      t.string :status
      t.text :notes

      t.timestamps
    end
  end
end
