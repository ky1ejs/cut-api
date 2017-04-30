class FilmController < ApplicationController
  def index
    want_to_watch_ids = device.user.want_to_watch_list.map { |film| film.id }
    all_films_json = Film.all.as_json(include: :posters)

    ratings_by_film_id = {}
    device.user.rated_list.each { |r| ratings_by_film_id[r.film_id] = r }
    ratings_film_ids = ratings_by_film_id.keys

    i = 0
    while i < all_films_json.count  do
      film_id = all_films_json[i]['id']

      all_films_json[i]['want_to_watch'] = want_to_watch_ids.include? film_id

      if ratings_film_ids.include? film_id
        all_films_json[i]['user_rating'] = ratings_by_film_id[film_id]
      end

      i += 1
    end

    render json: all_films_json
  end
end
