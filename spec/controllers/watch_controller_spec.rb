require 'rails_helper'

RSpec.describe WatchController, type: :controller do
  before(:each) do
    @film = create(:film, title: "Test")
    @device = create(:device)
  end

  after(:each) do
    @film.destroy
    @device.user.destroy
  end

  it "should index watch list" do
    watch = create(:unrated_watch, user: @device.user, film: @film)

    expected_json = [FilmSerializer.new(@film).serializable_hash]

    request.headers[:HTTP_DEVICE_ID] = @device.device_id
    get :index_watch_list

    expect(response.body).to eq expected_json.to_json
  end

  it "should index ratings" do
    watch = create(:rated_watch, user: @device.user, film: @film)

    expected_json = [WatchSerializer.new(watch).serializable_hash]

    request.headers[:HTTP_DEVICE_ID] = @device.device_id
    get :index_ratings

    expect(response.body).to eq expected_json.to_json
  end

  it "should add films to the watch list" do
    request.headers[:HTTP_DEVICE_ID] = @device.device_id
    post :create_watch, params: { :film_id => @film.id }

    expect(@device.user.rated_list.count).to eq 0
    expect(@device.user.want_to_watch_list.count).to eq 1
    expect(@device.user.watch_list.count).to eq 1
    expect(@device.user.watch_list.first.id).to eq @film.id
  end

  it "should rate films" do
    request.headers[:HTTP_DEVICE_ID] = @device.device_id
    rating = 5
    post :create_watch, params: { :film_id => @film.id, rating: rating }

    expect(@device.user.rated_list.count).to eq 1
    expect(@device.user.want_to_watch_list.count).to eq 0
    expect(@device.user.watch_list.count).to eq 1
    expect(@device.user.rated_list.first.film_id).to eq @film.id
    expect(@device.user.rated_list.first.rating).to eq rating
  end

  it "should delete watches" do
    watch = create(:watch, user: @device.user, film: @film)

    expect(@device.user.want_to_watch_list.count).to eq 1
    expect(@device.user.watch_list.count).to eq 1

    request.headers[:HTTP_DEVICE_ID] = @device.device_id
    delete :delete_watch, params: { :film_id => @film.id }

    @device.reload

    expect(@device.user.want_to_watch_list.count).to eq 0
    expect(@device.user.watch_list.count).to eq 0
  end
end
