class Watch < ApplicationRecord
  belongs_to :user
  belongs_to :film

  validates :rating, allow_nil: true, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }

  def watched
    !self.rating.nil? || !self.comment.nil?
  end

  def as_json(options = {})
    return super.as_json(options) if !self.watched || options[:include] != :film

    options = nil
    json = film.as_json(include: :posters)
    json[:user_rating] = super.as_json
    return json
  end
end
