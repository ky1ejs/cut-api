exec 'bundle exec rake db:migrate'
puts '###########'
puts 'ENV'
puts ENV['ENVIRONMENT']
puts '###########'
if ENV['ENVIRONMENT']&.uppercase != 'PRODUCTION'
  exec 'bundle exec rake db:seed'
  exec 'bundle exec rake films:fetch_flixster'
end
