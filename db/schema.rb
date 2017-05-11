# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170419182513) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "citext"
  enable_extension "uuid-ossp"

  create_table "devices", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "user_id",                       null: false
    t.citext   "name"
    t.integer  "platform",                      null: false
    t.datetime "last_seen",                     null: false
    t.string   "push_token"
    t.boolean  "is_dev_device", default: false, null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "film_providers", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.integer  "provider",         null: false
    t.uuid     "film_id",          null: false
    t.string   "provider_film_id", null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["provider", "film_id"], name: "index_film_providers_on_provider_and_film_id", unique: true, using: :btree
  end

  create_table "films", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.citext   "title",                null: false
    t.datetime "theater_release_date"
    t.integer  "running_time"
    t.string   "synopsis"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["title"], name: "index_films_on_title", unique: true, using: :btree
  end

  create_table "follows", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "follower_id"
    t.uuid     "following_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["follower_id", "following_id"], name: "index_follows_on_follower_id_and_following_id", unique: true, using: :btree
  end

  create_table "posters", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "film_id",    null: false
    t.citext   "url",        null: false
    t.integer  "size",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["size", "film_id"], name: "index_posters_on_size_and_film_id", unique: true, using: :btree
    t.index ["url"], name: "index_posters_on_url", unique: true, using: :btree
  end

  create_table "ratings", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "film_id",    null: false
    t.float    "score",      null: false
    t.integer  "count"
    t.integer  "source",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["source", "film_id"], name: "index_ratings_on_source_and_film_id", unique: true, using: :btree
  end

  create_table "users", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.citext   "email"
    t.citext   "username"
    t.string   "hashed_password"
    t.string   "salt"
    t.datetime "last_seen",       null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["username"], name: "index_users_on_username", unique: true, using: :btree
  end

  create_table "watches", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "user_id",    null: false
    t.uuid     "film_id",    null: false
    t.float    "rating"
    t.string   "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "film_id"], name: "index_watches_on_user_id_and_film_id", unique: true, using: :btree
  end

  add_foreign_key "devices", "users", on_delete: :cascade
  add_foreign_key "film_providers", "films", on_delete: :cascade
  add_foreign_key "follows", "users", column: "follower_id", on_delete: :cascade
  add_foreign_key "follows", "users", column: "following_id", on_delete: :cascade
  add_foreign_key "posters", "films", on_delete: :cascade
  add_foreign_key "ratings", "films", on_delete: :cascade
  add_foreign_key "watches", "films", on_delete: :cascade
  add_foreign_key "watches", "users", on_delete: :cascade
end
