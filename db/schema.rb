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

ActiveRecord::Schema.define(version: 20170405074452) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "citext"
  enable_extension "uuid-ossp"

  create_table "devices", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "user_id",                                    null: false
    t.citext   "name"
    t.integer  "type",                                       null: false
    t.datetime "last_seen",  default: '2017-04-05 21:05:26', null: false
    t.string   "push_token"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  create_table "films", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.citext   "title",                             null: false
    t.datetime "theater_release_date"
    t.integer  "running_time"
    t.float    "rotten_tomatoes_score"
    t.float    "external_user_score"
    t.integer  "external_user_score_count"
    t.integer  "external_user_want_to_watch_count"
    t.string   "synopsis"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.index ["title"], name: "index_films_on_title", unique: true, using: :btree
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

  create_table "users", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.citext   "email"
    t.datetime "last_seen",  default: '2017-04-05 21:05:26', null: false
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
  end

  create_table "want_to_watches", force: :cascade do |t|
    t.uuid     "user_id",    null: false
    t.uuid     "film_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "film_id"], name: "index_want_to_watches_on_user_id_and_film_id", unique: true, using: :btree
  end

  add_foreign_key "devices", "users", on_delete: :cascade
  add_foreign_key "posters", "films", on_delete: :cascade
  add_foreign_key "want_to_watches", "films", on_delete: :cascade
  add_foreign_key "want_to_watches", "users", on_delete: :cascade
end
