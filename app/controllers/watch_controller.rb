class WatchController < ApplicationController
  def index_watch_list
    render json: device.user.want_to_watch_list.map(&:film)
  end

  def index_ratings
    render json: device.user.rated_list
  end

  def create_watch
    film = Film.find(params[:film_id])
    watch = Watch.find_or_create_by(user: device.user, film: film)
    watch.rating = params[:rating]
    watch.save
    render status: 200
  end

  def delete_watch
    film = Film.find(params[:film_id])
    watch = Watch.find_by(user: device.user, film: film)
    watch.destroy
    render status: 200
  end
end
