class User < ApplicationRecord
  has_many :devices
  has_many :watch_list, foreign_key: :user_id, class_name: "WantToWatch"
  has_many :followers, foreign_key: :following_id, class_name: "Follow"
  has_many :following, foreign_key: :follower_id, class_name: "Follow"

  def can_login
    self.email != nil
  end

  def as_json(options = {})
    json = super(options)
    json['can_login'] = can_login
    json
  end

  before_validation :set_initial_last_seen, on: :create
  protected
  def set_initial_last_seen
    self.last_seen ||= Time.now
  end
end
