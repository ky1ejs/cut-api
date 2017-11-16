class Film < ApplicationRecord
  has_many :ratings
  has_many :posters
  has_many :trailers
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
