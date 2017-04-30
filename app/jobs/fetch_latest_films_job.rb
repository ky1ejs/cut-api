class FetchLatestFilmsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    FlixsterController.new.fetch_popular
  end
end
