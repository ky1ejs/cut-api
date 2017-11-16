class TrailerSerializer < ActiveModel::Serializer
  attributes :id, :url, :quality, :duration, :preview_image_url
end
