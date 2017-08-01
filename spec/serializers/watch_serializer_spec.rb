require "rails_helper"

RSpec.describe WatchSerializer do
  it 'correctly serializes a watch' do
    u = create(:full_user)
    f = create(:film)
    w = create(:watch, user: u, film: f)

    hash = WatchSerializer.new(w).serializable_hash

    expect(hash[:rating]).to eq w.rating
    expect(hash[:comment]).to eq w.comment
    expect(hash[:created_at]).to eq w.created_at
    expect(hash[:updated_at]).to eq w.updated_at
  end
end
