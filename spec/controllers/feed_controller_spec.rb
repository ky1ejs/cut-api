require 'rails_helper'

RSpec.describe FeedController, type: :controller do
  it 'returns array of watch_list activity from user\'s followers' do
    u = create(:full_user)
    following1 = create(:full_user)
    following2 = create(:full_user)

    f1 = create(:film)
    f2 = create(:film)

    watches = [
      create(:watch, film: f1, user: following1),
      create(:watch, film: f2, user: following2),
      create(:watch, film: f2, user: following1),
      create(:watch, rating: nil, film: f1, user: following2)
    ]

    u.following = [following1, following2]

    d = u.devices.first
    request.headers[:HTTP_DEVICE_ID] = d.device_id
    get :index

    expected_json = watches.map { |w| WatchSerializer.new(w).serializable_hash }
    expect(expected_json.to_json).to eq response.body
  end
end
