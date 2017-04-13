class SearchController < ApplicationController
  def search
    user_results = User.where "username LIKE ?", "%#{params[:term]}%"
    film_results = Film.where "title LIKE ?", "%#{params[:term]}%"
    json = {
      'users' => user_results.as_json,
      'films' => film_results.as_json(include: :posters)
    }
    render json: json
  end
end
