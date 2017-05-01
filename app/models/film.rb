class Film < ApplicationRecord
  has_many :ratings
  has_many :posters
  has_many :providers, class_name: "FilmProvider"

  validates :title, presence: true
  validates :running_time, numericality: { greater_than: 0 }, allow_nil: true

  def self.from_flixster(json)
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

    flixster_poster_type_map = {
      :thumbnail => :thumbnail,
      :profile => :medium,
      :detailed => :large
    }
    posters_json = json[:poster]

    f.posters = posters_json.map do |key, value|
      poster = Poster.new
      poster.size = flixster_poster_type_map[key]
      poster.url = posters_json[key]
      poster
    end

    reviews = json[:reviews]

    ratings = []

    r_t_score = reviews[:rottenTomatoes].try(:[], :rating)
    if !r_t_score.nil?
      critic_review_count = reviews[:criticsNumReviews]
      rotten_toms_rating = Rating.new
      rotten_toms_rating.rating = r_t_score / Float(100)
      rotten_toms_rating.rating_count = critic_review_count
      rotten_toms_rating.source = :rotten_tomatoes
      ratings.push(rotten_toms_rating)
    end

    fx_user_scores = reviews[:flixster]
    if !fx_user_scores.nil?
      fx_user_rating = Rating.new
      fx_user_rating.rating = fx_user_scores[:popcornScore] / Float(100)
      fx_user_rating.rating_count = fx_user_scores[:numScores]
      fx_user_rating.source = :flixster_users
      ratings.push(fx_user_rating)
    end

    f.ratings = ratings

    return f
  end

  def update_with_flixster_json(json)

    f = Film.from_flixster json

    self.title                = f.title
    self.running_time         = f.running_time
    self.theater_release_date = f.theater_release_date
    self.synopsis             = f.synopsis

    updated_posters_by_size = {}
    f.posters.each do |poster|
      updated_posters_by_size[poster.size] = poster
    end
    if !self.posters.nil?
      removed_posters = []
      self.posters.each do |poster|
        # Remove deleted posters
        if !updated_poster.keys.include? poster.size
          removed_posters.push poster
          next
        end

        poster.url = updated_posters_by_size[poster.size].url
        updated_posters_by_size.delete poster.size
      end
      self.posters -= removed_posters
      self.posters += updated_posters_by_size.values
    else
      self.posters = f.posters
    end

    updated_ratings_by_source = {}
    f.ratings.each do |r|
      updated_ratings_by_source[r.source] = r
    end
    if !self.ratings.nil?
      removed_ratings = []
      self.ratings.each do |r|
        if !updated_ratings_by_source.keys.include? r.source
          removed_ratings.push r
          next
        end

        updated_rating = updated_ratings_by_source[r.source]
        r.rating = updated_rating.rating
        r.rating_count = updated_rating.rating_count
        updated_ratings_by_source.delete r.source
      end
      self.ratings -= removed_ratings # Remove deleted ratings
      self.ratings += updated_ratings_by_source.values # Add new ratings
    else
      self.ratings = f.ratings
    end
  end

  def as_json(options = {})
    json = super(options)
    if options[:include] == :posters
      posters = {}
      json['posters'].each { |poster| posters[poster['size']] = poster }
      json['posters'] = posters
    end
    json
  end
end
