class CreateTrailers < ActiveRecord::Migration[5.0]
  def change
    enable_extension 'uuid-ossp'

    create_table :trailers, id: :uuid do |t|

      t.uuid    :film_id,           null: false
      t.citext  :url,               null: false
      t.integer :duration,          null: false
      t.integer :quality,           null: false
      t.string  :preview_image_url, null: false

      t.timestamps                  null: false
    end

    add_foreign_key :trailers, :films, column: :film_id, on_delete: :cascade
    add_index :trailers, [:quality, :film_id, :url], unique: true
  end
end

