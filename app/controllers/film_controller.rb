class FilmController < ApplicationController
  def index
    FlixsterController.new.fetch_popular

    film_ids = device.user.watch_list.map { |film| film.id }
    all_films_json = Film.all.as_json(include: :posters)

    i = 0
    while i < all_films_json.count  do
      all_films_json[i]['want_to_watch'] = film_ids.include? all_films_json[i]['id']
      i +=1
    end

    render json: all_films_json
  end
end
