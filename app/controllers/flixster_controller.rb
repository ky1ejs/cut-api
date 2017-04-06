require 'httparty'

class FlixsterController < ApplicationController
  def fetch_popular
    query = {
      "cbr" => "1",
      "country" => "UK",
      "deviceType" => "iPhone",
      "filter" => 'popular',
      "limit" => "100",
      "locale" => "en_GB",
      "version" => "7.13.3",
      "view" => "long"
    }
    response = HTTParty.get 'https://api.flixster.com/iphone/api/v2/movies.json', query: query
    json = JSON.parse response, symbolize_names: true
    films = []
    json.map do |film_json|
      film = Film.from_flixster film_json
      begin
        film.save!
        films.push film
      rescue => exception
        puts exception
      end
    end
    return films
  end
end
