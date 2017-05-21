require "rails_helper"

RSpec.describe FlixsterController, :type => :controller do
  it "updates existing films" do
    provider_film_id = 1000
    f = create(:flixster_film, provider_film_id: provider_film_id)

    title = "Interstellar"
    running_time = 97
    running_time_description = "1 hr. 37 min."
    theater_release_date = Date.new(2017, 4, 7)
    poster_width = 61
    poster_height = 91
    poster_size = :thumbnail
    synopsis = "Best movie ever"

    flixster_num_of_scores = 1134
    flxster_user_score = 63

    rotten_tomatoes_score = 50

    json = create(:flixster_film_json,
      id: provider_film_id,
      title: title,
      runningTime: running_time_description,
      theaterReleaseDate: {
        :year => theater_release_date.year.to_s,
        :month => theater_release_date.month.to_s,
        :day => theater_release_date.day.to_s
      },
      synopsis: synopsis,
      poster_size: poster_size,
      poster_width: poster_width,
      poster_height: poster_height,
      user_score_count: flixster_num_of_scores,
      user_score: flxster_user_score,
      rotten_tomatoes_score: rotten_tomatoes_score
    )

    movies_url_regex = Regexp.new FlixsterController.movies_url
    stub_request(:get, movies_url_regex).to_return(status: 200, body: [json].to_json)

    film_url_regex = Regexp.new "#{FlixsterController.movies_url}/#{provider_film_id}.json"
    stub_request(:get, film_url_regex).to_return(status: 200, body: json.to_json)

    FlixsterController.new.fetch_popular

    f.reload

    expect(f.title).to eq title
    expect(f.running_time).to eq running_time
    expect(f.theater_release_date).to eq theater_release_date
    expect(f.posters.first.url).to eq json[:poster].first[1]
    expect(f.posters.first.width).to eq poster_width
    expect(f.posters.first.height).to eq poster_height
    expect(f.synopsis).to eq synopsis

    expect(f.ratings.count).to eq 2

    expect(f.ratings[0].score).to eq rotten_tomatoes_score / Float(100)
    expect(f.ratings[0].count).to eq nil
    expect(f.ratings[0].source).to eq :rotten_tomatoes.to_s

    expect(f.ratings[1].score).to eq flxster_user_score / Float(100)
    expect(f.ratings[1].count).to eq flixster_num_of_scores
    expect(f.ratings[1].source).to eq :flixster_users.to_s
  end
end
