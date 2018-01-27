class WatchController < ApiController
  def index_watch_list
    user = User.find_by(username: params[:username])
    user ||= device.user
    render json: user.want_to_watch_list.map(&:film)
  end

  def index_ratings
    user = User.find_by(username: params[:username])
    user ||= device.user
    render json: user.rated_list
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
