class Poster < ApplicationRecord
  validates :film, :presence => true
  validates :film, uniqueness: { scope: [:width, :height] }

  belongs_to :film

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
