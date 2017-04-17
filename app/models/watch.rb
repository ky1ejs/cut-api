class Watch < ApplicationRecord
  belongs_to :user
  belongs_to :film

  validates :rating, allow_nil: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }

  def watched
    !self.rating.nil? || !self.comment.nil?
  end
end
