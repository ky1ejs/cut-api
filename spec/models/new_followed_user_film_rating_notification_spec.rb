require 'rails_helper'

RSpec.describe NewFollowedUserFilmRatingNotification, type: :model do
  it "should have the correct message" do
    r = 4

    u = create(:full_user)
    f = create(:film)
    w = create(:watch, rating: r, user: u, film: f)

    n = NewFollowedUserFilmRatingNotification.new
    n.user = create(:full_user)
    n.watch = w

    expect(n.message).to eq "#{u.username} just rated #{w.film.title} #{r}/5"
  end
end
