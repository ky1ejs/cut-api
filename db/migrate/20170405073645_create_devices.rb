class CreateDevices < ActiveRecord::Migration[5.0]
  def change
    enable_extension :citext
    enable_extension 'uuid-ossp'

    create_table :devices, id: :uuid do |t|
      t.uuid      :user_id,       null: false
      t.integer   :platform,      null: false
      t.datetime  :last_seen,     null: false
      t.boolean   :is_dev_device, null: false, default: false
      t.citext    :name
      t.string    :app_id
      t.string    :push_token

      t.timestamps null: false
    end

    add_foreign_key :devices, :users, column: :user_id, on_delete: :cascade
  end
end
