class Notification < ApplicationRecord
  belongs_to :user

  def save
    return if !super
    user.devices.each do |d|
      NotificationService.publish(message, d)
    end
  end
end
