# set :output, "/path/to/my/cron_log.log"

every 3.hours do
  runner "FetchLatestFilmsJob.perform_later"
end
