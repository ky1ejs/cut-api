class WatchListController < ApplicationController
  def index
    render json: Device.find(params[:device_id]).user.watch_list
  end

  def add_film_to_watch_list
    device = Device.find(params[:device_id])
    film = Film.find(params[:film_id])
    WantToWatch.find_or_create_by(user: device.user, film: film)
  end
end
