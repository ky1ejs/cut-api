class FilmController < ApiController
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

    render json: films
  end
end
