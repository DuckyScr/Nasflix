# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_03_10_114644) do
  create_table "active_storage_attachments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "episodes", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "episode_number"
    t.bigint "movie_id", null: false
    t.integer "season_number"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["movie_id"], name: "index_episodes_on_movie_id"
  end

  create_table "invitations", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "movie_night_id", null: false
    t.string "status"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["movie_night_id"], name: "index_invitations_on_movie_night_id"
    t.index ["user_id"], name: "index_invitations_on_user_id"
  end

  create_table "movie_nights", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "host_id", null: false
    t.bigint "movie_id", null: false
    t.text "notes"
    t.datetime "scheduled_at"
    t.datetime "updated_at", null: false
    t.index ["host_id"], name: "index_movie_nights_on_host_id"
    t.index ["movie_id"], name: "index_movie_nights_on_movie_id"
  end

  create_table "movies", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "content_type"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "director"
    t.string "genre"
    t.boolean "kid_friendly"
    t.string "title"
    t.datetime "updated_at", null: false
    t.integer "year"
  end

  create_table "reviews", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "author"
    t.text "content"
    t.datetime "created_at", null: false
    t.bigint "movie_id", null: false
    t.integer "rating"
    t.datetime "updated_at", null: false
    t.index ["movie_id"], name: "index_reviews_on_movie_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name"
    t.string "password_digest"
    t.string "role"
    t.datetime "updated_at", null: false
  end

  create_table "watch_progresses", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.boolean "completed", default: false
    t.datetime "created_at", null: false
    t.float "current_time", default: 0.0
    t.float "duration", default: 0.0
    t.bigint "episode_id"
    t.bigint "movie_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["episode_id"], name: "index_watch_progresses_on_episode_id"
    t.index ["movie_id"], name: "index_watch_progresses_on_movie_id"
    t.index ["user_id"], name: "index_watch_progresses_on_user_id"
  end

  create_table "watchlist_entries", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "end_date"
    t.bigint "movie_id", null: false
    t.text "notes"
    t.date "start_date"
    t.string "status"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["movie_id"], name: "index_watchlist_entries_on_movie_id"
    t.index ["user_id"], name: "index_watchlist_entries_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "episodes", "movies"
  add_foreign_key "invitations", "movie_nights"
  add_foreign_key "invitations", "users"
  add_foreign_key "movie_nights", "movies"
  add_foreign_key "movie_nights", "users", column: "host_id"
  add_foreign_key "reviews", "movies"
  add_foreign_key "watch_progresses", "episodes"
  add_foreign_key "watch_progresses", "movies"
  add_foreign_key "watch_progresses", "users"
  add_foreign_key "watchlist_entries", "movies"
  add_foreign_key "watchlist_entries", "users"
end
