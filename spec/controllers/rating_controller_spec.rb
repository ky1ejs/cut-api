require 'rails_helper'

RSpec.describe RatingController, type: :controller do
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

  it "should index ratings" do
    rating = Rating.new
    rating.film = @film
    rating.user = @device.user
    rating.rating = 5
    rating.save

    expected_json = [ rating.as_json(include: :film) ].to_json

    request.headers[:HTTP_DEVICE_ID] = "#{@device.type}_#{@device.id}"
    get :index

    expect(response.body).to eq expected_json
  end

  it "should rate films" do
    request.headers[:HTTP_DEVICE_ID] = "#{@device.type}_#{@device.id}"
    post :rate_film, params: {:film_id => @film.id, :rating => 5}

    expect(@device.user.ratings.count).to eq 1
    expect(@device.user.ratings.first.film_id).to eq @film.id
  end
end
