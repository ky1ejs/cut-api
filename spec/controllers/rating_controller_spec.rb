require 'rails_helper'

RSpec.describe RatingController, type: :controller do
  before(:each) do
    @film = Film.find_or_create_by(title: "Test")
    @film.save

    @device = Device.new
    @device.platform = :ios
    @device.save
  end

  after(:each) do
    @film.destroy
    @device.user.destroy
  end

  it "should index ratings" do
    watch = Watch.new
    watch.film = @film
    watch.user = @device.user
    watch.rating = 5
    watch.save

    expected_json = [ watch.as_json(include: :film) ].to_json

    request.headers[:HTTP_DEVICE_ID] = "#{@device.platform}_#{@device.id}"
    get :index

    expect(response.body).to eq expected_json
  end

  it "should rate films" do
    request.headers[:HTTP_DEVICE_ID] = "#{@device.platform}_#{@device.id}"
    post :rate_film, params: {:film_id => @film.id, :rating => 5}

    expect(@device.user.rated_list.count).to eq 1
    expect(@device.user.want_to_watch_list.count).to eq 0
    expect(@device.user.watch_list.count).to eq 1
    expect(@device.user.rated_list.first.film_id).to eq @film.id
  end

  it "should delete film ratings" do
    watch = Watch.new
    watch.film = @film
    watch.user = @device.user
    watch.rating = 5
    watch.save

    expect(@device.user.rated_list.count).to eq 1
    expect(@device.user.watch_list.count).to eq 1

    request.headers[:HTTP_DEVICE_ID] = "#{@device.platform}_#{@device.id}"
    delete :delete_rating, params: { :film_id => @film.id }

    @device.reload

    expect(@device.user.watch_list.count).to eq 0
    expect(@device.user.rated_list.count).to eq 0
  end
end
