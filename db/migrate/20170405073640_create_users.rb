class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    enable_extension :citext
    enable_extension 'uuid-ossp'

    create_table :users, id: :uuid do |t|
      t.citext    :email,           index: { :unique => true }
      t.citext    :username,        index: { :unique => true }
      t.string    :hashed_password
      t.string    :salt
      t.datetime  :last_seen,       null: false

      t.timestamps                  null: false
    end
  end
end
