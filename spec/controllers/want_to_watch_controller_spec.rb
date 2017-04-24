require 'rails_helper'

RSpec.describe WantToWatchController, type: :controller do
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

  it "should index watch list" do
    watch = Watch.new
    watch.film = @film
    watch.user = @device.user
    watch.save

    expected_json = [ watch.film.as_json(include: :posters) ].to_json

    request.headers[:HTTP_DEVICE_ID] = "#{@device.platform}_#{@device.id}"
    get :index

    expect(response.body).to eq expected_json
  end

  it "should add films to the watch list" do
    request.headers[:HTTP_DEVICE_ID] = "#{@device.platform}_#{@device.id}"
    post :add_film_to_watch_list, params: {:film_id => @film.id}

    expect(@device.user.rated_list.count).to eq 0
    expect(@device.user.want_to_watch_list.count).to eq 1
    expect(@device.user.watch_list.count).to eq 1
  end

  it "should delete film ratings" do
    watch = Watch.new
    watch.film = @film
    watch.user = @device.user
    watch.save

    expect(@device.user.want_to_watch_list.count).to eq 1
    expect(@device.user.watch_list.count).to eq 1

    request.headers[:HTTP_DEVICE_ID] = "#{@device.platform}_#{@device.id}"
    delete :delete_film_from_watch_list, params: { :film_id => @film.id }

    @device.reload

    expect(@device.user.want_to_watch_list.count).to eq 0
    expect(@device.user.rated_list.count).to eq 0
  end
end
