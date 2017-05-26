require 'rake'

namespace :films do
  desc "Fetch from Flixster"
  task :fetch_flixster => :environment do
    FlixsterController.new.fetch_popular
  end

  desc "Count Films"
  task :count => :environment do
    puts Film.all.count
  end

  desc "Send rotten tomato notifications out for upcoming films"
  task :notify => :environment do
    Film.all.each do |f|
      next if f.theater_release_date == nil

      r = f.rotten_tomato_rating
      next if r == nil

      User.all.each do |u|
        next if NewFilmRatingNotification.find_by(user_id: u.id, rating_id: r.id) == nil
        next if !u.notify_on_new_film
        next if r.score < u.film_rating_notification_threshold

        release_date_difference = ((r.film.theater_release_date - DateTime.now) / 1.day).to_i
        next if release_date_difference < -u.lastest_new_film_notification
        next if release_date_difference > u.earliest_new_film_notification

        n = NewFilmRatingNotification.new
        n.user = u
        n.rating = r
        n.save!
      end
    end
  end
end
