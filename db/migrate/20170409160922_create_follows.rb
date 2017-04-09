class CreateFollows < ActiveRecord::Migration[5.0]
  def change
    enable_extension 'uuid-ossp'

    create_table :follows, id: :uuid do |t|
      t.uuid :follower_id
      t.uuid :following_id

      t.timestamps
    end

    add_foreign_key :follows, :users, column: :follower_id, on_delete: :cascade
    add_foreign_key :follows, :users, column: :following_id, on_delete: :cascade
    add_index :follows, [:follower_id, :following_id], unique: true
  end
end
