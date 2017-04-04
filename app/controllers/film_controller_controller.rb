class FilmControllerController < ApplicationController
  def index
    render json: Film.all
  end
end
