class CreateWatchProgresses < ActiveRecord::Migration[8.1]
  def change
    create_table :watch_progresses do |t|
      t.references :user, null: false, foreign_key: true
      t.references :movie, null: false, foreign_key: true
      t.references :episode, null: true, foreign_key: true
      t.float :current_time, default: 0
      t.float :duration, default: 0
      t.boolean :completed, default: false

      t.timestamps
    end
  end
end
