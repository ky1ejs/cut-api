class Device < ApplicationRecord
  enum type: [ :ios, :android ]

  belongs_to :user

  before_create :set_initial_last_seen
  protected
  def set_initial_last_seen
    self.last_seen ||= Time.now
  end
end
