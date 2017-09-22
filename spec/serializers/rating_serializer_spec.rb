require "rails_helper"

RSpec.describe RatingSerializer do
  it 'correctly serializes a poster' do
    r = create(:rating)

    hash = RatingSerializer.new(r).serializable_hash

    expect(hash[:id]).to eq r.id
    expect(hash[:score]).to eq r.score
    expect(hash[:count]).to eq r.count
    expect(hash[:source]).to eq r.source
    expect(hash[:updated_at]).to eq r.updated_at
    expect(hash[:created_at]).to eq r.created_at
  end
end
