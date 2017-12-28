bundle exec rake db:migrate
if ENV['ENVIRONMENT']&.uppercase != 'PRODUCTION'
  bundle exec rake db:seed
  bundle exec rake films:fetch_flixster
end
