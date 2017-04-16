class RatingController < ApplicationController
  def index
    render json: device.user.ratings.as_json(include: :film)
  end

  def rate_film
    film = Film.find(params[:film_id])
    rating = Rating.find_or_create_by(user: device.user, film: film)
    rating.rating = params[:rating]
    rating.save
    render status: 200
  end

  def delete_rating
    film = Film.find(params[:film_id])
    rating = Rating.find_by(user: device.user, film: film)
    rating.destroy
    render status: 200
  end
end
