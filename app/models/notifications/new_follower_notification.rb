class NewFollowerNotification < Notification
  belongs_to :follow

  def message
    "#{follow.follower.username} followed you!"
  end
end
