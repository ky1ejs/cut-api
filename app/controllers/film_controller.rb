class FilmController < ApplicationController
  def index
    case params[:filter]
    when "releasing-soon"
      date_range = (DateTime.now + 1.days)..(DateTime.now + 1.week)
      films = Film.where(theater_release_date: date_range).order(theater_release_date: :desc).limit(100)
    when "hot-right-now"
      rating = Watch.where(rating: 3.5..5.0).order(updated_at: :desc).limit(100)
      films = rating.map { |r| r.film  }
    when "new-store-releases"
      films = Film.where(theater_release_date: 30.days.ago..(DateTime.now + 5.days)).limit(100)
    when "top-rated-all-time"
      rating = Watch.order(updated_at: :desc).limit(100)
      films = rating.map { |r| r.film  }
    else
      # "in-theaters" is default
      date_range = 30.days.ago..(DateTime.now + 5.days)
      films = Film.where(theater_release_date: date_range).order(theater_release_date: :desc).limit(100)
    end

    films_json = films.map { |f| FilmSerializer.new(f).serializable_hash }

    ratings_by_film_id = {}
    device.user.rated_list.each { |r| ratings_by_film_id[r.film_id] = r }

    want_to_watch_ids = device.user.want_to_watch_list.map { |film| film.id }

    i = 0
    while i < films_json.count  do
      film_id = films_json[i][:id]

      films_json[i]['want_to_watch'] = want_to_watch_ids.include? film_id

      if ratings_by_film_id.keys.include? film_id
        films_json[i]['user_rating'] = WatchSerializer.new(ratings_by_film_id[film_id]).serializable_hash
      end

      i += 1
    end

    render json: films_json
  end
end
