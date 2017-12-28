system "echo '###########'"
system "echo 'ENVIRONMENT'"
system 'echo $ENVIRONMENT'
system "echo '###########'"
system 'bundle exec rake db:migrate'
if ENV['ENVIRONMENT']&.uppercase != 'PRODUCTION'
  system 'bundle exec rake db:seed'
  system 'bundle exec rake films:fetch_flixster'
end
