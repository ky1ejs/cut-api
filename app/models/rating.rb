class Rating < ApplicationRecord
  enum source: [ :flixster_users, :rotten_tomatoes, :imdb_users, :metacritic, :metacritic_users ]

  belongs_to :film

  validates :score, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1 }

  def source_adjective
    case self.source
    when 'flixster_users'
      return "with"
    when 'rotten_tomatoes'
      return "on"
    when 'imdb_users'
      return "with"
    when 'metacritic'
      return "on"
    when 'metacritic_users'
      return "with"
    end
  end

  def source_name
    case self.source
    when 'flixster_users'
      return "Flixster Users"
    when 'rotten_tomatoes'
      return "Rotten Tomatoes"
    when 'imdb_users'
      return "IMDB Users"
    when 'metacritic'
      return "Metacritic"
    when 'metacritic_users'
      return "Metacritic Users"
    end
  end
end
