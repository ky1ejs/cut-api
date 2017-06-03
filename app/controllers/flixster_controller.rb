class FlixsterController < ApplicationController
  def self.movies_url
    'https://api.flixster.com/iphone/api/v2/movies'
  end

  def fetch_popular
    query = {
      "cbr" => "1",
      "country" => "UK",
      "deviceType" => "iPhone",
      "filter" => 'popular',
      "limit" => "100",
      "locale" => "en_GB",
      "version" => "7.13.4",
      "view" => "long"
    }

    begin
      response = HTTParty.get self.class.movies_url + '.json', query: query
    rescue => exception
      puts exception
    end

    return if response      == nil
    return if response.code != 200

    json = JSON.parse response, symbolize_names: true
    json.map { |json| update_or_create_film_with_id json[:id] }
  end

  def search(term)
    query = {
      "cbr" => "1",
      "country" => "US",
      "deviceType" => "iPhone",
      "filter" => term,
      "limit" => "3",
      "locale" => "en_GB",
      "version" => "7.13.4",
      "view" => "long"
    }

    begin
      response = HTTParty.get self.class.movies_url + '.json', query: query
    rescue => exception
      puts exception
    end

    return if response      == nil
    return if response.code != 200

    json = JSON.parse response, symbolize_names: true
    json.map { |json| update_or_create_film_with_id json[:id] }
  end

  def update_or_create_film_with_id(id)
    film = Flixster::Provider.get_film_with_id id
    begin
      film = Film.update_or_create_film film
    rescue => exception
      puts exception
    end
    film
  end
end
