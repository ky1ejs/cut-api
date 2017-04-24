require 'rails_helper'

RSpec.describe UserController, type: :controller do
  before(:each) do
    @follower = User.new
    @follower.username = 's-jobs'
    @follower.email = 'steve@apple.com'
    @follower.password = "Secure1234"
    @follower.save!

    follower_device = Device.new
    follower_device.platform = :ios
    follower_device.user = @follower
    follower_device.save!

    @device_id = "#{follower_device.platform}_#{follower_device.id}"

    @followee = User.new
    @followee.username = 's-woz'
    @followee.email = 'woz@apple.com'
    @followee.password = "Secure1234"
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

  it "should sign up full users" do
    device = Device.new
    device.platform = :ios
    device.save

    username = 'test'
    email = 'test@test.com'
    password = "Test12345"

    request.headers[:HTTP_DEVICE_ID] = "#{device.platform}_#{device.id}"
    post :create_login, params: {:username => username, :password => password, :email => email}

    expect { User.find_by(username: username) }.not_to raise_error

    user = User.find_by(username: username)
    expect(user.email).to eq email
    expect(user.check_password(password)).to eq true

    user.destroy
  end

  it "should return user's details" do
    device = Device.new
    device.platform = :ios
    device.save

    email = 'test@test.com'
    username = 'test'

    device.user.username = username
    device.user.email = email
    device.user.password = "Test12345"
    device.user.save

    request.headers[:HTTP_DEVICE_ID] = "#{device.platform}_#{device.id}"
    get :get_current_user

    response_json = JSON.parse(response.body)

    expect(response_json['email']).to eq email
    expect(response_json['username']).to eq username

    device.user.destroy
  end
end
