class SearchController < ApplicationController
  def search
    user_results = User.where "username LIKE ?", "%#{params[:term]}%"
    user_results_json = user_results.as_json

    i = 0
    following_user_ids = device.user.following.map { |user| user.id }
    while i < user_results_json.count  do
      user_results_json[i]['following'] = following_user_ids.include? user_results_json[i]['id']
      i +=1
    end

    film_results = Film.where "title LIKE ?", "%#{params[:term]}%"
    json = {
      'users' => user_results_json,
      'films' => film_results.as_json(include: :posters)
    }
    render json: json
  end
end
