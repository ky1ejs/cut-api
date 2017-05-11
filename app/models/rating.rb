class Rating < ApplicationRecord
  enum source: [ :flixster_users, :rotten_tomatoes, :imdb_users, :metacritic, :metacritic_users ]

  belongs_to :film

  validates :score, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1 }
end
