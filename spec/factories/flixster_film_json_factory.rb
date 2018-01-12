# factory :poster_json, class: Hash do
#   size :small
#   url "https://test.com/image.jpg"
# end
FactoryGirl.define do
  factory :flixster_film_json, class: Hash do
    skip_create

    transient do
      user_score_count      { 1000 }
      user_score            { 89 }
      rotten_tomatoes_score { 83 }
      poster_size           { '300x444' }
    end

    id "771382349"
    title "Interstellar"
    runningTime "1 hr. 37 min."
    year 2017
    theaterReleaseDate {{
      :year => "2017",
      :month => "4",
      :day => "07"
    }}
    trailer {{
      :low => "http://link.theplatform.com/s/NGweTC/media/iTHXNgNW4Lz5",
      :med => "http://link.theplatform.com/s/NGweTC/media/iTHXNgNW4Lz5",
      :high => "http://link.theplatform.com/s/NGweTC/media/iTHXNgNW4Lz5",
      :hd => "http://link.theplatform.com/s/NGweTC/media/iTHXNgNW4Lz5",
      :thumbnail => "http://resizing.flixster.com/QxyMqPE0tz_WSS8OJWwggnh_158=/171x128/v1.bjsxNDc5ODUzO2o7MTcyOTc7MjA0ODsxMDgwOzE5MjA",
      :duration => 151
    }}
    status "Live"
    playing true
    actors {[
      {
        "id": 162656441,
        "name": "Alec Baldwin"
      },
      {
        "id": 162652875,
        "name": "Steve Buscemi"
      },
      {
        "id": 351528089,
        "name": "Jimmy Kimmel"
      }
    ]}
    synopsis "Sweet ass movie"
    poster {{ :thumbnail => "https://poster.com/#{poster_size}" }}
    reviews {{
      :flixster => {
        :numScores => user_score_count,
        :popcornScore => user_score
      },
      :rottenTomatoes => {
        :rating => rotten_tomatoes_score
      }
    }}

    initialize_with { attributes }
  end
end
