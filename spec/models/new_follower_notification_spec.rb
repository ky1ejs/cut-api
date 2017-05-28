require 'rails_helper'

RSpec.describe NewFollowerNotification, type: :model do
  it "should have the correct message" do
    u = create(:full_user)
    f = create(:follow, follower: u)

    n = NewFollowerNotification.new
    n.follow = f

    expect(n.message).to eq "#{u.username} followed you!"
  end
end
