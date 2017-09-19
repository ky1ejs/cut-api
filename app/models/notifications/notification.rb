class Notification < ApplicationRecord
  belongs_to :user

  def save
    is_new = new_record?
    return unless super
    Rails.logger.debug NotificationService.send(self) if is_new
  end

  def save!
    is_new = new_record?
    return unless super
    Rails.logger.debug NotificationService.send(self) if is_new
  end

  def sent
    external_id.nil?
  end
end
