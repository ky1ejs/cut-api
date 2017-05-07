require 'rails_helper'

describe 'Whenever Schedule' do
  before do
    load 'Rakefile' # Makes sure rake tasks are loaded so you can assert in rake jobs
  end

  it 'makes sure `runner` statements exist' do
    schedule = Whenever::Test::Schedule.new(file: 'config/schedule.rb')

    expect(schedule.jobs[:runner].count).to eq 1

    # Executes the actual ruby statement to make sure all constants and methods exist:
    schedule.jobs[:runner].each { |job| instance_eval job[:task] }
  end

  it 'makes sure cron alive monitor is registered in minute basis' do
    schedule = Whenever::Test::Schedule.new(file: 'config/schedule.rb')

    expect(schedule.jobs[:runner].first[:task]).to eq 'FetchLatestFilmsJob.perform_later'
    expect(schedule.jobs[:runner].first[:command]).to eq "cd :path && :bundle_command :runner_command -e :environment ':task' :output"
    expect(schedule.jobs[:runner].first[:every]).to eq [3.hours]
  end
end
