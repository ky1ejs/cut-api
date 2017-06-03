class Film < ApplicationRecord
  has_many :ratings
  has_many :posters
  has_many :providers, class_name: "FilmProvider"

  validates :title, presence: true
  validates :running_time, numericality: { greater_than: 0 }, allow_nil: true

  def update_with_film(updated_film)
    self.title                = updated_film.title
    self.running_time         = updated_film.running_time
    self.theater_release_date = updated_film.theater_release_date
    self.synopsis             = updated_film.synopsis

    if self.posters != nil
      update_to_date_poster_urls = updated_film.posters.map { |poster| poster.url }
      removed_posters = self.posters.map { |poster| update_to_date_poster_urls.include?(poster.url) ? nil : poster }.compact

      existing_poster_urls = self.posters.map { |poster| poster.url }
      added_posters = updated_film.posters.map { |poster| existing_poster_urls.include?(poster.url) ? nil : poster }.compact

      removed_posters.each { |posters| posters.destroy! }
      self.posters = self.posters - removed_posters + added_posters
    else
      self.posters = f.posters
    end

    updated_ratings_by_source = {}
    updated_film.ratings.each do |r|
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
      self.ratings = updated_film.ratings
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

    json['relative_theater_release_date'] = theater_release_date.relative_time_string if theater_release_date != nil

    json
  end

  def self.update_or_create_film(film)
    existing_providers = film.providers.map do |prov|
      FilmProvider.find_by(provider_film_id: prov.provider_film_id, provider: prov.provider)
    end
    existing_providers = existing_providers.compact

    if existing_providers.count == 0
      film.save!
      return film
    else
      existing_film = existing_providers.first.film
      existing_film.update_with_film film
      return existing_film
    end
  end

  def rotten_tomato_rating
    self.ratings.each { |r| return r if r.source == 'rotten_tomatoes' }
    nil
  end
end
