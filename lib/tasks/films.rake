require 'rake'

namespace :films do
  desc "Fetch from Flixster"
  task :fetch_flixster => :environment do
    FlixsterController.new.fetch_popular
  end

  desc "Count Films"
  task :count => :environment do
    puts Film.all.count
  end
end
