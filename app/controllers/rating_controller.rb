class RatingController < ApplicationController
  def index
    render json: device.user.rated_list.as_json(include: :film)
  end

  def rate_film
    film = Film.find(params[:film_id])
    watch = Watch.find_or_create_by(user: device.user, film: film)
    watch.rating = params[:rating]
    watch.save
    render status: 200
  end

  def delete_rating
    film = Film.find(params[:film_id])
    watch = Watch.find_by(user: device.user, film: film)
    watch.destroy
    render status: 200
  end
end
