class CreateFilmProviders < ActiveRecord::Migration[5.0]
  def change
    enable_extension 'uuid-ossp'

    create_table :film_providers, id: :uuid do |t|
      t.integer :provider, null: false
      t.uuid :film_id, null: false
      t.string :provider_film_id, null: false

      t.timestamps
    end

    add_foreign_key :film_providers, :films, column: :film_id, on_delete: :cascade
    add_index :film_providers, [:provider, :film_id], unique: true
  end
end
