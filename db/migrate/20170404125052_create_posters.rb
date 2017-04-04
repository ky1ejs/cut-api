class CreatePosters < ActiveRecord::Migration[5.0]
  def change
    create_table :posters do |t|
      t.integer :film_id

      t.timestamps
    end
  end
end
