class CreatePosters < ActiveRecord::Migration[5.0]
  def change
    create_table :posters do |t|
      t.integer :film_id,   null: false
      t.string :url,        null: false
      t.integer :size,      null: false

      t.timestamps          null: false
    end

    add_foreign_key :posters, :films, column: :film_id, on_delete: :cascade
  end
end
