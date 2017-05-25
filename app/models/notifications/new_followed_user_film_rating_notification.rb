class NewFollowedUserFilmRatingNotification < Notification
  belongs_to :watch

  def message
    rating_int = watch.rating.to_i
    rating = rating_int == watch.rating ? rating_int : watch.rating
    "#{watch.user.username} just rated #{watch.film.title} #{rating}/5"
  end
end
