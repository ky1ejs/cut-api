class Rating < ApplicationRecord
  enum source: [ :flixster_users, :rotten_tomatoes, :imdb_users, :metacritic, :metacritic_users ]
  belongs_to :film
end
