class User < ApplicationRecord
  has_many :devices
  has_many :watch_list, foreign_key: :user_id, class_name: "WantToWatch"

  before_validation :set_initial_last_seen, on: :create
  protected
  def set_initial_last_seen
    self.last_seen ||= Time.now
  end
end
