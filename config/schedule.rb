set :output, "/var/log/cron.log"

# Inherit all ENV variables
ENV.each { |k, v| env(k, v) }

every 2.hours do
  rake "films:fetch_flixster"
end
