class Film < ApplicationRecord
  has_many :ratings
  has_many :posters
  has_many :providers, class_name: "FilmProvider"

  validates :title, presence: true
  validates :running_time, numericality: { greater_than: 0 }, allow_nil: true
  validates :rotten_tomatoes_score, :external_user_score, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1 }, allow_nil: true

  def self.from_flixster(json)
    title = json[:title]

    running_time_string = json[:runningTime]
    running_time_regex = /(?<hours>\d{1}) hr\. ?(?<mins>\d{1,2})?/
    running_time_data = running_time_string.match(running_time_regex)

    if !running_time_data.nil?
      hours = running_time_data[:hours].to_i * 60
      running_time = hours + running_time_data[:mins].to_i
    end

    r_t_score = json[:reviews][:rottenTomatoes].try(:[], :rating)
    rotten_tomatoes_score = r_t_score / Float(100) unless r_t_score.nil?

    fx_user_scores = json[:reviews][:flixster]
    fx_popcorn_score = fx_user_scores[:popcornScore]
    external_user_score = fx_popcorn_score / Float(100) unless fx_popcorn_score.nil?
    external_user_score_count = fx_user_scores[:numScores]
    external_user_want_to_watch_count = fx_user_scores[:numWantToSee]

    t_release_date = json[:theaterReleaseDate]
    year = t_release_date[:year].to_i
    month = t_release_date[:month].to_i
    day = t_release_date[:day].to_i
    theater_release_date = Date.new year, month, day unless year == 0 || month == 0 || day == 0

    f = Film.new
    f.title = title
    f.running_time = running_time
    f.rotten_tomatoes_score = rotten_tomatoes_score
    f.external_user_score = external_user_score
    f.external_user_score_count = external_user_score_count
    f.external_user_want_to_watch_count = external_user_want_to_watch_count
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

    return f
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
