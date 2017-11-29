class TrailerSerializer < ActiveModel::Serializer
  attributes :id, :url, :quality, :preview_image_url
end
