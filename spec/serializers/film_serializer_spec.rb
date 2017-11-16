require "rails_helper"

RSpec.describe FilmSerializer do
  it 'correctly serializes a film' do
    f = create(:film)

    hash = FilmSerializer.new(f).serializable_hash

    expect(hash[:title]).to eq f.title
    expect(hash[:relative_theater_release_date]).to eq f.theater_release_date.relative_time_string
    expect(hash[:synopsis]).to eq f.synopsis
    expect(hash[:theater_release_date]).to eq f.theater_release_date
    expect(hash[:running_time]).to eq f.running_time
    expect(hash[:title]).to eq f.title

    expect(hash[:posters].count).to eq 5
    expect(hash[:posters].keys).to include "thumbnail", "smallest", "largest", "profile", "hero"

    expect(hash[:trailers].keys).to include "low", "medium", "high", "hd"

    hash[:posters].values.each { |p|
      dimensions = [p[:width], p[:height]]
      expect(dimensions).to all be_an(Integer)
      expect(p[:url]).not_to eq nil
    }
  end
end
