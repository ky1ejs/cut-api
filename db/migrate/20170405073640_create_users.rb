class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    enable_extension :citext
    enable_extension 'uuid-ossp'

    create_table :users, id: :uuid do |t|
      t.citext    :email,                                   index: { :unique => true }
      t.citext    :username,                                index: { :unique => true }
      t.string    :hashed_password
      t.string    :salt
      t.datetime  :last_seen,                               null: false

      t.boolean   :notify_on_new_film,                      null: false, default: true
      t.float     :film_rating_notification_threshold,      null: false, default: 0.80
      t.integer   :earliest_new_film_notification,          null: false, default: 3
      t.integer   :lastest_new_film_notification,           null: false, default: 25

      t.boolean   :notify_on_follower_rating,               null: false, default: true
      t.integer   :follower_rating_notification_threshold,  null: false, default: 4

      t.timestamps                                          null: false
    end
  end
end
