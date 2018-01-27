class UserSerializer < ActiveModel::Serializer
  attributes :email, :username, :is_full_user, :follower_count, :following_count, :watch_list_count, :rated_count
  attribute :profile_image_url, key: :profile_image

  def email
    ids = object.devices.map(&:id)
    object.email if ids.include? device&.id
  end

  def follower_count
    object.followers.count
  end

  def following_count
    object.following.count
  end

  def watch_list_count
    object.want_to_watch_list.count
  end

  def rated_count
    object.rated_list.count
  end

  def device
    scope if scope.instance_of? Device
  end
end
