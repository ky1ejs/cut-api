class CreateFilms < ActiveRecord::Migration[5.0]
  def change
    create_table :films do |t|
      t.string      :title,                      null: false
      t.datetime    :theater_release_date
      t.integer     :running_time,               null: false
      t.float       :rotten_tomatoes_score
      t.float       :external_user_score
      t.float       :external_user_score_count
      t.string      :synopsis

      t.timestamps  null: false
    end
  end
end
