class WatchListController < ApplicationController
  def index
    render json: device.user.watch_list.map { |watch| watch.film }
  end

  def add_film_to_watch_list
    film = Film.find(params[:film_id])
    WantToWatch.find_or_create_by(user: device.user, film: film)
    render status: 200
  end
end
