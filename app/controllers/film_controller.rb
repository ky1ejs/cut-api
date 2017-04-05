class FilmController < ApplicationController
  def index
    FlixsterController.new.fetch_popular
    render json: Film.all
  end
end
