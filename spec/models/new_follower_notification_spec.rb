require 'rails_helper'

RSpec.describe NewFollowerNotification, type: :model do
  it "should have the correct message" do
    u = create(:full_user)
    n = NewFollowerNotification.new
    n.follower = u

    expect(n.message).to eq "#{u.username} followed you!"
  end
end
