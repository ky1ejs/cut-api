class RemoveUrlIndexFromPosters < ActiveRecord::Migration[5.0]
  def up
    remove_index :posters, :url
  end

  def down
    add_index :posters, :url
  end
end
