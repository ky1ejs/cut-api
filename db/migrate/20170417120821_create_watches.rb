class CreateWatches < ActiveRecord::Migration[5.0]
  def change
    enable_extension 'uuid-ossp'

    create_table :watches, id: :uuid do |t|
      t.uuid :user_id, null: false
      t.uuid :film_id, null: false
      t.float :rating
      t.string :comment

      t.timestamps
    end

    add_foreign_key :watches, :users, column: :user_id, on_delete: :cascade
    add_foreign_key :watches, :films, column: :film_id, on_delete: :cascade
    add_index :watches, [:user_id, :film_id], unique: true
  end
end
