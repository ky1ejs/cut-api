class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    enable_extension :citext
    enable_extension 'uuid-ossp'

    create_table :users, id: :uuid do |t|
      t.citext    :email,     index: { :unique => true }
      t.datetime  :last_seen, null: false

      t.timestamps
    end
  end
end
