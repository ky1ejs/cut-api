class RatingSerializer < ActiveModel::Serializer
  attributes :id, :score, :count, :source, :created_at, :updated_at
end
