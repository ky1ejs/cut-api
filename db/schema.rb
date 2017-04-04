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

ActiveRecord::Schema.define(version: 20170404125052) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "citext"
  enable_extension "uuid-ossp"

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

  add_foreign_key "posters", "films", on_delete: :cascade
end
