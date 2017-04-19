class CreateRatings < ActiveRecord::Migration[5.0]
  def change
    enable_extension 'uuid-ossp'

    create_table :ratings, id: :uuid do |t|
      t.uuid    :film_id,       null: false
      t.float   :rating,        null: false
      t.integer :rating_count,  null: false
      t.integer :source,        null: false

      t.timestamps              null: false
    end

    add_foreign_key :ratings, :films, column: :film_id, on_delete: :cascade
    add_index :ratings, [:source, :film_id], unique: true
  end
end
