require "rails_helper"

RSpec.describe PosterSerializer do
  it 'correctly serializes a poster' do
    p = build(:poster)

    hash = PosterSerializer.new(p).serializable_hash
    dimensions = [hash[:width], hash[:height]]

    expect(dimensions).to all be_an(Integer)
    expect(hash[:url]).not_to eq nil
  end
end
