class Film < ApplicationRecord
    validates :rotten_tomatoes_score, :external_user_score, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1 }, allow_nil: true
    validates :running_time, numericality: { greater_than: 0 }, allow_nil: true
    validates :title, presence: true
    validates :synopsis, presence: true, allow_nil: true

    has_many :posters

    def self.from_flixster(json)
      title = json[:title]

      running_time_string = json[:runningTime]
      running_time_regex = /(?<hours>\d{1}) hr\. ?(?<mins>\d{1,2})?/
      running_time_data = running_time_string.match(running_time_regex)

      if !running_time_data.nil?
        hours = running_time_data[:hours].to_i * 60
        running_time = hours + running_time_data[:mins].to_i
      end

      f = Film.new
      f.title = title
      f.running_time = running_time
      return f
    end
end
