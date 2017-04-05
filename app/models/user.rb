class User < ApplicationRecord
  has_many :devices
  has_many :want_to_watch

  before_create :set_initial_last_seen
  protected
  def set_initial_last_seen
    self.last_seen ||= Time.now
  end
end
