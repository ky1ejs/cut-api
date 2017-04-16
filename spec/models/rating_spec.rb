require 'rails_helper'

RSpec.describe Rating, type: :model do
  before(:each) do
    @film = Film.find_or_create_by(title: "Test")
    @film.save

    @user = User.new
    @user.save
  end

  after(:each) do
    @film.destroy
    @user.destroy
  end

  it "should have a rating no greater than 5" do
    rating = Rating.new
    rating.film = @film
    rating.user = @user
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
    rating.user = @user
    rating.rating = -1

    begin
      rating.save
    rescue
    end

    expect(rating.new_record?).to eq true
  end
end
