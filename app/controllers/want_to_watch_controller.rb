class WantToWatchController < ApplicationController
  def index
    puts device.user.watch_list.count
    render json: device.user.want_to_watch_list.map { |w| w.film  }.as_json(include: :posters)
  end

  def add_film_to_watch_list
    film = Film.find(params[:film_id])
    Watch.find_or_create_by(user: device.user, film: film)
    render status: 200
  end

  def delete_film_from_watch_list
    film = Film.find(params[:film_id])
    watch = Watch.find_by(user: device.user, film: film)
    watch.destroy
    render status: 200
  end
end
