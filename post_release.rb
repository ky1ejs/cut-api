system "echo '###########'"
system "echo 'ENVIRONMENT'"
system 'echo $ENVIRONMENT'
system "echo '###########'"
system "echo ''"
system "echo ''"
system "echo '###########'"
system "echo 'Run bundle exec rake db:migrate'"
system "echo '###########'"
system 'bundle exec rake db:migrate'
if ENV['ENVIRONMENT']&.uppercase != 'PRODUCTION'
  system "echo ''"
  system "echo ''"
  system "echo '###########'"
  system "echo 'Run bundle exec rake db:seed'"
  system "echo '###########'"
  system 'bundle exec rake db:seed'

  system "echo ''"
  system "echo ''"
  system "echo '###########'"
  system "echo 'Run bundle exec rake films:fetch_flixster'"
  system "echo '###########'"
  system 'bundle exec rake films:fetch_flixster'
end
