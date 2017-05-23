class Poster < ApplicationRecord
  validates :film, :presence => true
  validates :film, uniqueness: { scope: [:width, :height] }

  belongs_to :film

  def self.from_flixster_url(url)
    regex = /https?:\/\/resizing.flixster.com\/.+\/(?<width>[0-9]+)x(?<height>[0-9]+)\/.+/
    size = url.match regex

    width = size.try(:[], :width).try { to_i }
    height = size.try(:[], :height).try { to_i }

    return if width == nil || width.to_i == 0
    return if height == nil || height.to_i == 0
    return if width >= height

    poster = Poster.new
    poster.width = width
    poster.height = height
    poster.url = url
    poster
  end

  def size_name
    PosterSize.new(self).name
  end

  def size_index
    PosterSize.new(self).index
  end

  def short_side_length
    [width, height].min
  end
end
