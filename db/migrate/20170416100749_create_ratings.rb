class CreateRatings < ActiveRecord::Migration[5.0]
  def change
    enable_extension 'uuid-ossp'

    create_table :ratings, id: :uuid do |t|
      t.uuid :user_id, null: false
      t.uuid :film_id, null: false
      t.integer :rating, null: false

      t.timestamps null: false
    end

    add_foreign_key :ratings, :users, column: :user_id, on_delete: :cascade
    add_foreign_key :ratings, :films, column: :film_id, on_delete: :cascade
    add_index :ratings, [:user_id, :film_id], unique: true
  end
end
