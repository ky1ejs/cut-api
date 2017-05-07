require 'rails_helper'

describe 'Whenever Schedule' do
  before do
    load 'Rakefile' # Makes sure rake tasks are loaded so you can assert in rake jobs
  end

  it 'makes sure `runner` statements exist' do
    schedule = Whenever::Test::Schedule.new(file: 'config/schedule.rb')

    expect(schedule.jobs[:rake].count).to eq 1

    # Executes the actual ruby statement to make sure all constants and methods exist:
    schedule.jobs[:runner].each { |job| instance_eval job[:task] }
  end

  it 'makes sure cron alive monitor is registered in minute basis' do
    schedule = Whenever::Test::Schedule.new(file: 'config/schedule.rb')

    expect(schedule.jobs[:rake].first[:task]).to eq 'films:fetch_flixster'
    expect(schedule.jobs[:rake].first[:command]).to eq "cd :path && :environment_variable=:environment :bundle_command rake :task --silent :output"
    expect(schedule.jobs[:rake].first[:every]).to eq [2.hours]
  end
end
