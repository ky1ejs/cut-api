require "rails_helper"

RSpec.describe Film, :type => :model do


  it "parses a movie from Flixster" do
    title = "Interstellar"
    running_time = 97
    running_time_description = "1 hr. 37 min."
    theater_release_date = Date.new(2017, 4, 7)
    poster_url = "http://poster.com/image.jpg"
    poster_size = :thumbnail
    synopsis = "Best movie ever"

    flixster_num_of_scores = 1134
    flxster_user_score = 63

    rotten_tomatoes_score = 50

    json = create(:flixster_film_json,
      title: title,
      runningTime: running_time_description,
      theaterReleaseDate: {
        :year => theater_release_date.year.to_s,
        :month => theater_release_date.month.to_s,
        :day => theater_release_date.day.to_s
      },
      synopsis: synopsis,
      poster_size: poster_size,
      poster_url: poster_url,
      user_score_count: flixster_num_of_scores,
      user_score: flxster_user_score,
      rotten_tomatoes_score: rotten_tomatoes_score
    )

    f = Film.from_flixster(json)
    f.save

    expect(f.title).to eq title
    expect(f.running_time).to eq running_time
    expect(f.theater_release_date).to eq theater_release_date
    expect(f.posters.first.url).to eq poster_url
    expect(f.posters.first.size).to eq poster_size.to_s
    expect(f.synopsis).to eq synopsis

    expect(f.ratings.count).to eq 2

    expect(f.ratings[0].rating).to eq rotten_tomatoes_score / Float(100)
    expect(f.ratings[0].rating_count).to eq nil
    expect(f.ratings[0].source).to eq :rotten_tomatoes.to_s

    expect(f.ratings[1].rating).to eq flxster_user_score / Float(100)
    expect(f.ratings[1].rating_count).to eq flixster_num_of_scores
    expect(f.ratings[1].source).to eq :flixster_users.to_s

    f.destroy

    expect(f.ratings.count).to eq 0
  end

  it "updates from flixster json" do
    f = Film.new
    f.title = "Test title"
    f.save!

    title = "Interstellar"
    running_time = 97
    running_time_description = "1 hr. 37 min."
    theater_release_date = Date.new(2017, 4, 7)
    poster_url = "http://poster.com/image.jpg"
    poster_size = :thumbnail
    synopsis = "Best movie ever"

    flixster_num_of_scores = 1134
    flxster_user_score = 63

    rotten_tomatoes_score = 50

    json = create(:flixster_film_json,
      title: title,
      runningTime: running_time_description,
      theaterReleaseDate: {
        :year => theater_release_date.year.to_s,
        :month => theater_release_date.month.to_s,
        :day => theater_release_date.day.to_s
      },
      synopsis: synopsis,
      poster_size: poster_size,
      poster_url: poster_url,
      user_score_count: flixster_num_of_scores,
      user_score: flxster_user_score,
      rotten_tomatoes_score: rotten_tomatoes_score
    )

    f.update_with_flixster_json json

    expect(f.title).to eq title
    expect(f.running_time).to eq running_time
    expect(f.theater_release_date).to eq theater_release_date
    expect(f.posters.first.url).to eq poster_url
    expect(f.posters.first.size).to eq poster_size.to_s
    expect(f.synopsis).to eq synopsis

    expect(f.ratings.count).to eq 2

    expect(f.ratings[0].rating).to eq rotten_tomatoes_score / Float(100)
    expect(f.ratings[0].rating_count).to eq nil
    expect(f.ratings[0].source).to eq :rotten_tomatoes.to_s

    expect(f.ratings[1].rating).to eq flxster_user_score / Float(100)
    expect(f.ratings[1].rating_count).to eq flixster_num_of_scores
    expect(f.ratings[1].source).to eq :flixster_users.to_s

    f.destroy!
  end
end
