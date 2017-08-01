class WatchSerializer < ActiveModel::Serializer
  attributes :id, :film, :user, :rating, :comment, :created_at, :updated_at

  def film
    FilmSerializer.new(object.film).serializable_hash
  end

  def user
    UserSerializer.new(object.user).serializable_hash
  end
end
