class FilmControllerController < ApplicationController
  def index
    FlixsterControllerController.new.fetch_popular
    render json: Film.all
  end
end
