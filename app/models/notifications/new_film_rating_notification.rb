class NewFilmRatingNotification < Notification
  belongs_to :rating

  def message
    "#{rating.film.title} has hit #{(rating.score * 100).round}% #{rating.source_adjective} #{rating.source_name}"
  end
end
