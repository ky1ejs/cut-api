class Follow < ApplicationRecord
  belongs_to :following, foreign_key: :following_id, class_name: "User"
  belongs_to :follower, foreign_key: :follower_id, class_name: "User"

  validates :following, :follower, :presence => true
  validate :validate_following, :validate_full_users

  protected

  def validate_following
    errors.add :base, "A user cannot follow themself" if self.following_id == self.follower_id
  end

  def validate_full_users
    message = "Users must be full users before they can follow or be followed by other users"
    errors.add :follower, message if !self.follower.is_full_user
    errors.add :following, message if !self.following.is_full_user
  end
end
