class CreateNotifications < ActiveRecord::Migration[5.0]
  def change
    enable_extension 'uuid-ossp'

    create_table :notifications, id: :uuid do |t|
      t.uuid        :user_id, null: false
      t.string      :type,    null: false
      t.boolean     :read,    null: false, default: false
      t.timestamps            null: false

      # NewFilmRatingNotification
      t.uuid        :rating_id

      # NewFollowerNotfication
      t.uuid        :follow_id

      # NewFollowedUserFilmRatingNotification
      t.uuid        :watch_id
    end

    add_foreign_key :notifications, :users,     column: :user_id,     on_delete: :cascade
    add_foreign_key :notifications, :ratings,   column: :rating_id,   on_delete: :cascade
    add_foreign_key :notifications, :follows,   column: :follow_id,   on_delete: :cascade
    add_foreign_key :notifications, :watches,   column: :watch_id,    on_delete: :cascade
  end
end
