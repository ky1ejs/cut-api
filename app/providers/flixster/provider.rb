module Flixster
  class Provider
    def self.get_film_with_id(id)
      query = {
        "cbr" => "1",
        "country" => "US",
        "deviceType" => "iPhone",
        "locale" => "en_GB",
        "version" => "7.13.3",
        "view" => "long"
      }

      url = "https://api.flixster.com/iphone/api/v2/movies/#{id}.json"

      begin
        response = HTTParty.get url, query: query
      rescue => exception
        puts exception
      end

      return if response      == nil
      return if response.code != 200

      json = JSON.parse response, symbolize_names: true

      parse_film(json)
    end

    def self.parse_film(json)
      title = json[:title]

      running_time_string = json[:runningTime]
      running_time_regex = /(?<hours>\d{1}) hr\. ?(?<mins>\d{1,2})?/
      running_time_data = running_time_string.match(running_time_regex)

      if !running_time_data.nil?
        hours = running_time_data[:hours].to_i * 60
        running_time = hours + running_time_data[:mins].to_i
      end

      t_release_date = json[:theaterReleaseDate]
      year = t_release_date[:year].to_i
      month = t_release_date[:month].to_i
      day = t_release_date[:day].to_i
      theater_release_date = Date.new year, month, day unless year == 0 || month == 0 || day == 0

      f = Film.new
      f.title = title
      f.running_time = running_time
      f.synopsis = json[:synopsis]
      f.theater_release_date = theater_release_date

      provider = FilmProvider.new
      provider.provider = :flixster
      provider.provider_film_id = json[:id].to_s
      f.providers = [provider]

      f.posters = json[:poster].values.select { |url| url.length > 0 }.map { |url| Poster.from_flixster_url url }.compact

      reviews = json[:reviews]

      ratings = []

      r_t_score = reviews[:rottenTomatoes].try(:[], :rating)
      if !r_t_score.nil?
        critic_review_count = reviews[:criticsNumReviews]
        rotten_toms_rating = Rating.new
        rotten_toms_rating.score = r_t_score / Float(100)
        rotten_toms_rating.count = critic_review_count
        rotten_toms_rating.source = :rotten_tomatoes
        ratings.push(rotten_toms_rating)
      end

      fx_user_scores = reviews[:flixster]
      if !fx_user_scores.nil?
        fx_user_rating = Rating.new
        fx_user_rating.score = fx_user_scores[:popcornScore] / Float(100)
        fx_user_rating.count = fx_user_scores[:numScores]
        fx_user_rating.source = :flixster_users
        ratings.push(fx_user_rating)
      end

      f.ratings = ratings

      f
    end
  end
end
