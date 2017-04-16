require 'rails_helper'

RSpec.describe Rating, type: :model do
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
    rating = Rating.new
    rating.film = @film
    rating.user = @device.user
    rating.rating = 6

    begin
      rating.save
    rescue
    end

    expect(rating.new_record?).to eq true
  end

  it "should not have a rating less than 1" do
    rating = Rating.new
    rating.film = @film
    rating.user = @device.user
    rating.rating = -1

    begin
      rating.save
    rescue
    end

    expect(rating.new_record?).to eq true
  end

  it "should be deleted when the user is deleted" do
    rating = Rating.new
    rating.film = @film
    rating.user = @device.user
    rating.rating = 5

    rating.save

    expect(@device.user.ratings.count).to eq 1

    @device.user.destroy

    expect { Rating.find(rating.id) }.to raise_exception(ActiveRecord::RecordNotFound)
  end
end
