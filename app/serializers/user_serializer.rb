class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :username, :is_full_user, :follower_count, :following_count
  attribute :profile_image_url, key: :profile_image

  def follower_count
    object.followers.count
  end

  def following_count
    object.following.count
  end
end
