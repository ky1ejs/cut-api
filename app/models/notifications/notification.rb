class Notification < ApplicationRecord
  belongs_to :user

  def save
    is_new = new_record?
    return if !super
    if is_new
      user.devices.each { |d| Rails.logger.debug NotificationService.publish(message, d) }
    end
  end

  def save!
    is_new = new_record?
    return if !super
    if is_new
      user.devices.each { |d| Rails.logger.debug NotificationService.publish(message, d) }
    end
  end
end
