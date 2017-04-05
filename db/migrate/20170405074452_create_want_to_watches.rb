class CreateWantToWatches < ActiveRecord::Migration[5.0]
  def change
    enable_extension 'uuid-ossp'

    create_table :want_to_watches do |t|
      t.uuid :user_id, null: false
      t.uuid :film_id, null: false

      t.timestamps
    end

    add_foreign_key :want_to_watches, :users, column: :user_id, on_delete: :cascade
    add_foreign_key :want_to_watches, :films, column: :film_id, on_delete: :cascade
    add_index :want_to_watches, [:user_id, :film_id], unique: true
  end
end
