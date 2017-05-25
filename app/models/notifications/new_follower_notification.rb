class NewFollowerNotification < Notification
  belongs_to :follower, foreign_key: :follower_id, class_name: "User"

  def message
    "#{follower.username} followed you!"
  end
end
