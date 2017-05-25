require 'rails_helper'

RSpec.describe NewFilmRatingNotification, type: :model do
  it "should have the correct message" do
    title = "Interstellar"
    score = 82

    d = create(:device_with_push_token)
    f = create(:rotten_tomatoes_rated_film, title: title, score: score / 100.0)
    r = f.ratings.first

    n = NewFilmRatingNotification.new
    n.user = d.user
    n.rating = r

    expect(n.message).to eq "#{title} has hit #{score}% on Rotten Tomatoes"
  end
end
