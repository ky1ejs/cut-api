require "rails_helper"

RSpec.describe Poster, :type => :model do
  it "inits from a flixster url" do
    width = 61
    height = 91

    url = "http://resizing.flixster.com/fViMBuvaOCW7GqOs0L_pNeBHsb8=/#{width}x#{height}/v1.bTsxMTQyMDkxMTtqOzE3MzIzOzIwNDg7MzM3NTs1MDAw"

    poster = Poster.from_flixster_url url

    expect(poster.width).to eq width
    expect(poster.height).to eq height
    expect(poster.url).to eq url
  end
end
