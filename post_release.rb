def run(cmd)
  print_message "Run #{cmd}"
  system cmd
end

def print_message(message)
  system "echo '###########'"
  system "echo \"#{message}\""
  system "echo '###########'"
end


print_message 'ENVIRONMENT = $ENVIRONMENT'
if ENV['RAILS_ENV']&.upcase == 'PRODUCTION'
  run'bundle exec rake db:migrate'
else
  run'bundle exec rake db:migrate:reset'
  run 'bundle exec rake db:seed'
  run 'bundle exec rake films:fetch_flixster'
end
