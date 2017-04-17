require 'rails_helper'

RSpec.describe Watch, type: :model do
  before(:each) do
    @film = Film.find_or_create_by(title: "Test")
    @film.save

    @device = Device.new
    @device.type = :ios
    @device.save
  end

  after(:each) do
    @film.destroy
    @device.user.destroy
  end

  it "should have a rating no greater than 5" do
    watch = Watch.new
    watch.film = @film
    watch.user = @device.user
    watch.rating = 6

    begin
      watch.save
    rescue
    end

    expect(watch.new_record?).to eq true
  end

  it "should not have a rating less than 1" do
    watch = Watch.new
    watch.film = @film
    watch.user = @device.user
    watch.rating = -1

    begin
      watch.save
    rescue
    end

    expect(watch.new_record?).to eq true
  end

  it "should be deleted when the user is deleted" do
    watch = Watch.new
    watch.film = @film
    watch.user = @device.user
    watch.rating = 5

    watch.save

    expect(@device.user.watch_list.count).to eq 1

    @device.user.destroy

    expect { Watch.find(watch.id) }.to raise_exception(ActiveRecord::RecordNotFound)
  end
end
