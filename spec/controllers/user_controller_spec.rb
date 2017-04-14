require 'rails_helper'

RSpec.describe UserController, type: :controller do
  before(:each) do
    @follower = User.new
    @follower.username = 's-jobs'
    @follower.email = 'steve@apple.com'
    @follower.password = ""
    @follower.save!

    follower_device = Device.new
    follower_device.type = :ios
    follower_device.user = @follower
    follower_device.save!

    @device_id = "#{follower_device.type}_#{follower_device.id}"

    @followee = User.new
    @followee.username = 's-woz'
    @followee.email = 'woz@apple.com'
    @followee.password = ""
    @followee.save!
  end

  after(:each) do
    @follower.destroy!
    @followee.destroy!
  end

  it "follows users" do
    expect(@follower.followers.count).to eq 0
    expect(@follower.following.count).to eq 0
    expect(@followee.followers.count).to eq 0
    expect(@followee.following.count).to eq 0

    request.headers[:HTTP_DEVICE_ID] = @device_id
    post :follow_unfollow_user, params: {:username => @followee.username}

    expect(@follower.followers.count).to eq 0
    expect(@follower.following.count).to eq 1
    expect(@followee.followers.count).to eq 1
    expect(@followee.following.count).to eq 0
  end

  it "unfollows users" do
    expect(@follower.followers.count).to eq 0
    expect(@follower.following.count).to eq 0
    expect(@followee.followers.count).to eq 0
    expect(@followee.following.count).to eq 0

    @follower.following.push(@followee)

    expect(@follower.followers.count).to eq 0
    expect(@follower.following.count).to eq 1
    expect(@followee.followers.count).to eq 1
    expect(@followee.following.count).to eq 0

    request.headers[:HTTP_DEVICE_ID] = @device_id
    delete :follow_unfollow_user, params: {:username => @followee.username}

    expect(@follower.followers.count).to eq 0
    expect(@follower.following.count).to eq 0
    expect(@followee.followers.count).to eq 0
    expect(@followee.following.count).to eq 0
  end
end
