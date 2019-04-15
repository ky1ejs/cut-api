class UserSerializer < ActiveModel::Serializer
  attribute :email,             if: -> { is_authenticated_user && object.is_full_user }
  attribute :is_full_user,      if: -> { is_authenticated_user }
  attribute :following,         if: -> { !is_authenticated_user && device != nil }
  attribute :username,          if: -> { object.is_full_user }
  attribute :follower_count,    if: -> { object.is_full_user }
  attribute :following_count,   if: -> { object.is_full_user }
  attribute :profile_image_url, key: :profile_image, if: -> { object.is_full_user }

  attributes :id, :watch_list_count, :rated_count

  def following
    device.user.following.map(&:id).include? object.id
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

  ###

  def is_authenticated_user
    object.id == device&.user&.id
  end

  def device
    scope if scope.instance_of? Device
  end
end
