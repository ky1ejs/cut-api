require 'httparty'

class FlixsterController < ApplicationController
  def self.url
    'https://api.flixster.com/iphone/api/v2/movies.json'
  end

  def query
    {
      "cbr" => "1",
      "country" => "UK",
      "deviceType" => "iPhone",
      "filter" => 'popular',
      "limit" => "100",
      "locale" => "en_GB",
      "version" => "7.13.3",
      "view" => "long"
    }
  end

  def fetch_popular
    films = []

    begin
      response = HTTParty.get self.class.url, query: query
      if response.code == 200
        json = JSON.parse response, symbolize_names: true
        json.map do |film_json|
          provider = FilmProvider.find_by(provider_film_id: film_json[:id], provider: :flixster)
          if provider.nil?
            film = Film.from_flixster film_json
          else
            film = provider.film
            film.update_with_flixster_json film_json
          end
          begin
            film.save!
            films.push film
          rescue => exception
            puts exception
          end
        end
      end
    rescue => exception
      puts exception
    end

    return films
  end
end
