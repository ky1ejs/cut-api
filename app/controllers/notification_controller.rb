class NotificationController < ApplicationController
  def test
    NotificationService.publish(params[:message])
  end
end
