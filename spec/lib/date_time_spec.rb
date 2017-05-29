require "rails_helper"

RSpec.describe DateTime, :type => :class do
  it "gives the correct relative_time_string for today" do
    expect(DateTime.now.relative_time_string).to eq 'today'

    expect((DateTime.now - 1.day).relative_time_string).to eq 'yesterday'
    expect((DateTime.now + 1.day).relative_time_string).to eq 'tomorrow'

    expect((DateTime.now + 2.days).relative_time_string).to eq 'in 2 days'
    expect((DateTime.now - 2.days).relative_time_string).to eq '2 days ago'

    expect((DateTime.now + 20.days).relative_time_string).to eq 'in 20 days'
    expect((DateTime.now - 20.days).relative_time_string).to eq '20 days ago'

    expect((DateTime.now + 50.days).relative_time_string).to eq 'in 1 month'
    expect((DateTime.now - 50.days).relative_time_string).to eq '1 month ago'

    expect((DateTime.now + 90.days).relative_time_string).to eq 'in 3 months'
    expect((DateTime.now - 90.days).relative_time_string).to eq '3 months ago'

    expect((DateTime.now + 400.days).relative_time_string).to eq 'in about 1 year'
    expect((DateTime.now - 400.days).relative_time_string).to eq 'about 1 year ago'

    expect((DateTime.now + 800.days).relative_time_string).to eq 'in about 2 years'
    expect((DateTime.now - 800.days).relative_time_string).to eq 'about 2 years ago'
  end
end
