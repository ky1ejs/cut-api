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

ActiveRecord::Schema.define(version: 20180113213045) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "citext"
  enable_extension "uuid-ossp"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_type"
    t.integer  "resource_id"
    t.string   "author_type"
    t.integer  "author_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree
  end

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "devices", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "user_id",                       null: false
    t.integer  "platform",                      null: false
    t.datetime "last_seen",                     null: false
    t.boolean  "is_dev_device", default: false, null: false
    t.citext   "name"
    t.string   "app_id"
    t.string   "push_token"
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

  create_table "notifications", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "user_id",                          null: false
    t.string   "type",                             null: false
    t.boolean  "seen",             default: false, null: false
    t.string   "push_id"
    t.integer  "push_status"
    t.string   "push_status_code"
    t.string   "push_response"
    t.uuid     "rating_id"
    t.uuid     "follow_id"
    t.uuid     "watch_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  create_table "posters", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "film_id",    null: false
    t.citext   "url",        null: false
    t.integer  "width",      null: false
    t.integer  "height",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["width", "height", "film_id"], name: "index_posters_on_width_and_height_and_film_id", unique: true, using: :btree
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

  create_table "trailers", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "film_id",           null: false
    t.citext   "url",               null: false
    t.integer  "quality",           null: false
    t.string   "preview_image_url", null: false
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["quality", "film_id", "url"], name: "index_trailers_on_quality_and_film_id_and_url", unique: true, using: :btree
  end

  create_table "users", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.citext   "email"
    t.citext   "username"
    t.string   "hashed_password"
    t.string   "salt"
    t.datetime "last_seen",                                             null: false
    t.boolean  "notify_on_new_film",                     default: true, null: false
    t.float    "film_rating_notification_threshold",     default: 0.8,  null: false
    t.integer  "earliest_new_film_notification",         default: 3,    null: false
    t.integer  "lastest_new_film_notification",          default: 30,   null: false
    t.boolean  "notify_on_follower_rating",              default: true, null: false
    t.integer  "follower_rating_notification_threshold", default: 4,    null: false
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
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
  add_foreign_key "notifications", "follows", on_delete: :cascade
  add_foreign_key "notifications", "ratings", on_delete: :cascade
  add_foreign_key "notifications", "users", on_delete: :cascade
  add_foreign_key "notifications", "watches", on_delete: :cascade
  add_foreign_key "posters", "films", on_delete: :cascade
  add_foreign_key "ratings", "films", on_delete: :cascade
  add_foreign_key "trailers", "films", on_delete: :cascade
  add_foreign_key "watches", "films", on_delete: :cascade
  add_foreign_key "watches", "users", on_delete: :cascade
end
