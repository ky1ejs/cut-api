class CreateFilms < ActiveRecord::Migration[5.0]
  def change
    enable_extension :citext
    enable_extension 'uuid-ossp'

    create_table :films, id: :uuid do |t|
      t.citext      :title,                      null: false, index: { :unique => true }
      t.datetime    :theater_release_date
      t.integer     :running_time
      t.float       :rotten_tomatoes_score
      t.float       :external_user_score
      t.float       :external_user_score_count
      t.string      :synopsis

      t.timestamps  null: false
    end
  end
end
