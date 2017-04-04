class Film < ApplicationRecord
    validates :rotten_tomatoes_score, :external_user_score, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1 }, allow_nil: true
    validates :running_time, numericality: { greater_than: 0 }, allow_nil: true
    validates :title, presence: true
    validates :synopsis, presence: true, allow_nil: true

    has_many :posters

    def self.from_flixster(json)
      f = Film.new
      f.title = json[:title]
      f.running_time = json[:runningTime].to_i
      return f
    end
end
