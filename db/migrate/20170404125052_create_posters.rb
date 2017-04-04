class CreatePosters < ActiveRecord::Migration[5.0]
  def change
    enable_extension :citext

    create_table :posters do |t|
      t.integer :film_id,   null: false
      t.citext  :url,       null: false, index: { :unique => true }
      t.integer :size,      null: false

      t.timestamps          null: false
    end

    add_foreign_key :posters, :films, column: :film_id, on_delete: :cascade
    add_index :posters, [:size, :film_id], unique: true
  end
end
