class Device < ApplicationRecord
  enum platform: [ :ios, :android ]

  belongs_to :user

  def device_id
    "#{self.platform}_#{self.id}"
  end

  before_validation :set_initial_last_seen, :set_initial_user, on: :create

  protected

  def set_initial_last_seen
    self.last_seen ||= Time.now
  end

  def set_initial_user
    self.user ||= User.new
  end
end
