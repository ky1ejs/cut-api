class Trailer < ApplicationRecord
  validates :film, :presence => true
  validates :film, uniqueness: { scope: :quality }

  enum quality: [ :low, :medium, :high, :hd ]

  belongs_to :film
end
