class SearchController < ApplicationController
  def search
    user_results = User.where "username LIKE ?", "%#{params[:term]}%"
    user_results_json = user_results.map { |u| UserSerializer.new(u).serializable_hash }

    following_user_ids = device.user.following.map { |user| user.id }
    user_results_json.each do |u|
      u[:following] = following_user_ids.include? u[:id]
    end

    film_results = Film.where "title LIKE ?", "%#{params[:term]}%"
    film_results = FlixsterController.new.search(params[:term]) if film_results.count < 1 || params[:search_all_providers] == true

    json = {
      :users => user_results_json,
      :films => film_results.map { |f| FilmSerializer.new(f).serializable_hash }
    }

    render json: json
  end
end
