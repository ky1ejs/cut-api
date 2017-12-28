exec 'bundle exec rake db:migrate'
if ENV['ENVIRONMENT']&.uppercase != 'PRODUCTION'
  exec 'bundle exec rake db:seed'
  exec 'bundle exec rake films:fetch_flixster'
end
