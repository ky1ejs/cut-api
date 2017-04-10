class User < ApplicationRecord
  has_many :devices
  has_many :watch_list_records, foreign_key: :user_id, class_name: "WantToWatch"
  has_many :watch_list, through: :watch_list_records, source: :film
  has_many :follower_records, foreign_key: :following_id, class_name: "Follow"
  has_many :following_records, foreign_key: :follower_id, class_name: "Follow"
  has_many :followers, through: :follower_records
  has_many :following, through: :following_records

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
