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

    f.posters = json[:poster].values.select { |url| url.length > 0 }.map { |url| Poster.from_flixster_url url }

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

    return f
  end

  def update_with_flixster_json(json)
    f = Film.from_flixster json

    self.title                = f.title
    self.running_time         = f.running_time
    self.theater_release_date = f.theater_release_date
    self.synopsis             = f.synopsis

    if self.posters != nil
      new_poster_urls = f.posters.map { |poster| poster.url }
      removed_posters = self.posters.map { |poster| new_poster_urls.include?(poster.url) ? nil : poster }.compact

      existing_poster_urls = self.posters.map { |poster| poster.url }
      added_posters = f.posters.map { |poster| existing_poster_urls.include?(poster.url) ? nil : poster }.compact

      removed_posters.each { |posters| posters.destroy! }
      self.posters = self.posters - removed_posters + added_posters
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
        r.score = updated_rating.score
        r.count = updated_rating.count
        updated_ratings_by_source.delete r.source
      end
      self.ratings -= removed_ratings # Remove deleted ratings
      self.ratings += updated_ratings_by_source.values # Add new ratings
    else
      self.ratings = f.ratings
    end

    self.save!
  end

  def as_json(options = {})
    options[:include] ||= [:ratings]
    json = super(options)

    grouped_posters = self.posters.group_by { |poster| poster.size_index }
    posters = grouped_posters.map { |k, v| v.sort_by { |poster| poster.short_side_length } }
    posters = posters.map { |g| g.last } # get the biggest for each size group

    size_sorted_posters = self.posters.sort_by { |poster| poster.short_side_length }
    smallest_poster = size_sorted_posters.first
    largest_poster = size_sorted_posters.last

    poster_json = {}
    posters.each { |poster| poster_json[poster.size_name] = poster.as_json }
    poster_json['smallest'] = smallest_poster
    poster_json['largest'] = largest_poster

    profile_poster = poster_json['large']
    if profile_poster == nil
      all_posters = grouped_posters.values.flatten
      profile_poster = all_posters.first
      puts all_posters
      all_posters.each do |poster|
        if poster.short_side_length > 500
          next
        end
        if  profile_poster.short_side_length < poster.short_side_length
          profile_poster = poster
        end
      end
    end
    poster_json['profile'] = profile_poster

    hero_poster = poster_json['extra_large']
    if hero_poster == nil
      all_posters = grouped_posters.values.flatten
      hero_poster = all_posters.first
      all_posters.each do |poster|
        next if poster.short_side_length > 1000
        hero_poster = poster if hero_poster.short_side_length < poster.short_side_length
      end
    end
    poster_json['hero'] = hero_poster

    json['posters'] = poster_json
    json
  end
end
