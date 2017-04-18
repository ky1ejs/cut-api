class FilmProvider < ApplicationRecord
  enum provider: [ :flixster, :imdb ]
  validates :film_id, uniqueness: { scope: :provider }

  belongs_to :film
end
