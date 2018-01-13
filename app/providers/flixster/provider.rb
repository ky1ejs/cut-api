module Flixster
  class Provider
    def self.get_film_json_with_id(id)
      query = {
        'cbr' => '1',
        'country' => 'US',
        'deviceType' => 'iPhone',
        'locale' => 'en_GB',
        'version' => '7.13.3',
        'view' => 'long'
      }

      url = "https://api.flixster.com/iphone/api/v2/movies/#{id}.json"

      begin
        response = HTTParty.get url, query: query
      rescue => exception
        puts exception
      end

      return if response.nil?
      return if response.code != 200

      JSON.parse response, symbolize_names: true
    end

    def self.get_film_with_id(id)
      parse_film(get_film_json_with_id(id))
    end

    def self.parse_film(json)
      title = json[:title]

      # Running Time
      running_time_string = json[:runningTime]
      running_time_regex = /(?<hours>\d{1}) hr\. ?(?<mins>\d{1,2})?/
      running_time_data = running_time_string.match(running_time_regex)
      unless running_time_data.nil?
        hours = running_time_data[:hours].to_i * 60
        running_time = hours + running_time_data[:mins].to_i
      end

      # Release Date
      t_release_date = json[:theaterReleaseDate]
      year = t_release_date[:year].to_i
      month = t_release_date[:month].to_i
      day = t_release_date[:day].to_i
      theater_release_date = Date.new year, month, day unless year == 0 || month == 0 || day == 0

      # Create Film
      f = Film.new
      f.title = title
      f.running_time = running_time
      f.synopsis = json[:synopsis]
      f.theater_release_date = theater_release_date

      # Provider
      provider = FilmProvider.new
      provider.provider = :flixster
      provider.provider_film_id = json[:id].to_s
      f.providers = [provider]

      # Posters
      urls = Set.new json[:poster].values
      f.posters = urls.reject(&:empty?).map { |url| parse_poster url }.compact

      # Ratings
      reviews = json[:reviews]
      ratings = []
      r_t_score = reviews[:rottenTomatoes].try(:[], :rating)
      unless r_t_score.nil?
        critic_review_count = reviews[:criticsNumReviews]
        rotten_toms_rating = Rating.new
        rotten_toms_rating.score = r_t_score / Float(100)
        rotten_toms_rating.count = critic_review_count
        rotten_toms_rating.source = :rotten_tomatoes
        ratings.push(rotten_toms_rating)
      end
      fx_user_scores = reviews[:flixster]
      unless fx_user_scores.nil?
        fx_user_rating = Rating.new
        fx_user_rating.score = fx_user_scores[:popcornScore] / Float(100)
        fx_user_rating.count = fx_user_scores[:numScores]
        fx_user_rating.source = :flixster_users
        ratings.push(fx_user_rating)
      end
      f.ratings = ratings

      # Trailers
      trailer_json = json[:trailer]
      trailer_preview_image = trailer_json[:thumbnail]
      flixster_cut__quality_map = {
        low: :low,
        med: :medium,
        high: :high,
        hd: :hd
      }
      f.trailers = flixster_cut__quality_map.map { |k, v|
        t = Trailer.new
        t.quality = v
        t.url = trailer_json[k]
        t.preview_image_url = trailer_preview_image
        t
      }

      f
    end

    def self.parse_poster(url)
      Rollbar.scope!(poster_url: url)

      size = FastImage.size(url, timeout: 5.0)

      return if size.nil? # couldn't fetch size
      return if size[0].nil? || size[0].zero? || size[1].nil? || size[1].to_i.zero?
      return if size[0] >= size[1]

      poster = Poster.new
      poster.width = size[0]
      poster.height = size[1]
      poster.url = url
      poster
    end
  end
end
