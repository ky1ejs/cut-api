class SearchController < ApiController
  def search
    user_results = User.where "username LIKE ?", "%#{params[:term]}%"

    film_results = Film.where "title LIKE ?", "%#{params[:term]}%"
    film_results = FlixsterController.new.search(params[:term]) if film_results.count < 1 || params[:search_all_providers] == true

    json = {
      user: user_results.map { |u| UserSerializer.new(u).serializable_hash },
      films: film_results.map { |f| FilmSerializer.new(f).serializable_hash }
    }

    render json: json
  end
end
