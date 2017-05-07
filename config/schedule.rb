# set :output, "/path/to/my/cron_log.log"

every 2.hours do
  runner "FetchLatestFilmsJob.perform_later"
end
