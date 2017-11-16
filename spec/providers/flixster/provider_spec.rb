require "rails_helper"

RSpec.describe Flixster::Provider, :type => :class do
  it "parses a movie from Flixster" do
    title = "Interstellar"
    running_time = 97
    running_time_description = "1 hr. 37 min."
    theater_release_date = Date.new(2017, 4, 7)
    poster_width = 61
    poster_height = 91
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
      poster_width: poster_width,
      poster_height: poster_height,
      user_score_count: flixster_num_of_scores,
      user_score: flxster_user_score,
      rotten_tomatoes_score: rotten_tomatoes_score
    )

    f = Flixster::Provider.parse_film(json)
    f.save

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

    expect(f.trailers.count).to eq 4

    f.destroy

    expect(f.ratings.count).to eq 0
  end

  it "parses poster urls" do
    urls = [
      {
        'width' => 61,
        'height' => 91,
        'url' => "http://resizing.flixster.com/6IW9Gb-ooPSDOKJQr2XnAPbjB3c=/61x91/v1.bTsxMjM1MDcyMDtqOzE3Mzk3OzIwNDg7NDE4Nzs2MTM3"
      },
      {
        'width' => 120,
        'height' => 176,
        'url' => "http://resizing.flixster.com/8L2FdKU2P_EpHtwhhWoHC9Ukm-k=/120x176/v1.bTsxMjM1MDcyMDtqOzE3Mzk3OzIwNDg7NDE4Nzs2MTM3"
      },
      {
        'width' => 180,
        'height' => 264,
        'url' => "http://resizing.flixster.com/EcMNRjyAjfs9nxlvH3i2-BWOgG8=/180x264/v1.bTsxMjM1MDcyMDtqOzE3Mzk3OzIwNDg7NDE4Nzs2MTM3"
      },
      {
        'width' => 320,
        'height' => 469,
        'url' => "http://resizing.flixster.com/jc5OvtgurU9FBygm04e7ZXF1fb8=/320x469/v1.bTsxMjM1MDcyMDtqOzE3Mzk3OzIwNDg7NDE4Nzs2MTM3"
      },
      {
        'width' => 500,
        'height' => 733,
        'url' => "http://resizing.flixster.com/rJ9l4LrDu0Boko_L0XnsskoPKTw=/500x733/v1.bTsxMjM1MDcyMDtqOzE3Mzk3OzIwNDg7NDE4Nzs2MTM3"
      },
      {
        'width' => 800,
        'height' => 1173,
        'url' => "http://resizing.flixster.com/RXOK7oZALdWcYNg7xRCgw4LaqCE=/800x1173/v1.bTsxMjM1MDcyMDtqOzE3Mzk3OzIwNDg7NDE4Nzs2MTM3"
      },
      {
        'width' => 4187,
        'height' => 6137,
        'url' => "http://resizing.flixster.com/Ol6Vre-t7dA_kFQ5YtZ7G1kRIwY=/4187x6137/v1.bTsxMjM1MDcyMDtqOzE3Mzk3OzIwNDg7NDE4Nzs2MTM3"
      }
    ]

    urls.each do |url|
      parsed_url = Flixster::Provider.parse_poster url['url']
      expect(parsed_url.url).to eq url['url']
      expect(parsed_url.width).to eq url['width']
      expect(parsed_url.height).to eq url['height']
    end
  end
end
