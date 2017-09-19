class Notification < ApplicationRecord
  belongs_to :user

  def save
    is_new = new_record?
    return unless super
    send if is_new
  end

  def save!
    is_new = new_record?
    return unless super
    send if is_new
  end

  def sent
    external_id.nil?
  end

  private

  def send
    Rails.logger.debug NotificationService.publish(self)
  end
end
