class WatchListController < ApplicationController
  def index
    render json: Device.find(params[:device_id]).user.watch_list
  end
end
