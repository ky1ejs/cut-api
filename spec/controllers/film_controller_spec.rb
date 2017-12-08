require 'rails_helper'

RSpec.describe FilmController, type: :controller do
  it 'should return user ratings and watch status in line with films' do
    u = create(:full_user)
    f = create(:film)
    w = create(:watch, film: f, user: u, rating: 5)

    request.headers[:HTTP_DEVICE_ID] = u.devices.first.device_id
    get :index

    json = JSON.parse response.body
    rating_json = json.first
    expect(json.count).to eq 1
    expect(rating_json.keys.include?("user_rating")).to eq true
    expect(rating_json["user_rating"].to_json).to eq WatchSerializer.new(w).serializable_hash.to_json
  end
end
