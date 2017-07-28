require 'rails_helper'

RSpec.describe UserController, type: :controller do
  it "follows users" do
    follower = create(:full_user)
    followee = create(:full_user)

    expect(follower.followers.count).to eq 0
    expect(follower.following.count).to eq 0
    expect(followee.followers.count).to eq 0
    expect(followee.following.count).to eq 0

    request.headers[:HTTP_DEVICE_ID] = follower.devices.first.device_id
    post :follow_unfollow_user, params: {:username => followee.username}

    expect(follower.followers.count).to eq 0
    expect(follower.following.count).to eq 1
    expect(followee.followers.count).to eq 1
    expect(followee.following.count).to eq 0
  end

  it "unfollows users" do
    follower = create(:full_user)
    followee = create(:full_user)

    expect(follower.followers.count).to eq 0
    expect(follower.following.count).to eq 0
    expect(followee.followers.count).to eq 0
    expect(followee.following.count).to eq 0

    follower.following.push(followee)

    expect(follower.followers.count).to eq 0
    expect(follower.following.count).to eq 1
    expect(followee.followers.count).to eq 1
    expect(followee.following.count).to eq 0

    request.headers[:HTTP_DEVICE_ID] = follower.devices.first.device_id
    delete :follow_unfollow_user, params: {:username => followee.username}

    expect(follower.followers.count).to eq 0
    expect(follower.following.count).to eq 0
    expect(followee.followers.count).to eq 0
    expect(followee.following.count).to eq 0
  end

  it "should sign up full users" do
    device = create(:device)

    username = 'test'
    email = 'test@test.com'
    password = "Test12345"

    request.headers[:HTTP_DEVICE_ID] = device.device_id
    post :create_login, params: {:username => username, :password => password, :email => email}

    expect { User.find_by(username: username) }.not_to raise_error

    user = User.find_by(username: username)
    expect(user.email).to eq email
    expect(user.check_password(password)).to eq true
  end

  it "should return user's details" do
    device = create(:device)

    email = 'test@test.com'
    username = 'test'

    device.user.username = username
    device.user.email = email
    device.user.password = "Test12345"
    device.user.save

    request.headers[:HTTP_DEVICE_ID] = device.device_id
    get :get_current_user

    response_json = JSON.parse(response.body)

    expect(response_json['email']).to eq email
    expect(response_json['username']).to eq username
  end

  it "logs a valid username and password in" do
    username = 'test'
    password = 'Password123'
    initial_device = create(:device_with_user, username: username, password: password)
    new_device = create(:device)

    expect(initial_device.user.devices.count).to eq 1

    request.headers[:HTTP_DEVICE_ID] = new_device.device_id
    post :login, params: {:email_or_username => username, password: password}

    new_device.reload

    expect(response.status).to eq 200
    expect(initial_device.user.username).to           eq new_device.user.username
    expect(initial_device.user.id).to                 eq new_device.user.id
    expect(initial_device.user.devices.count).to      eq 2
  end

  it "logs a valid email and password in" do
    email = 'test@test.com'
    password = 'Password123'
    initial_device = create(:device_with_user, email: email, password: password)
    new_device = create(:device)

    request.headers[:HTTP_DEVICE_ID] = new_device.device_id
    post :login, params: {:email_or_username => email, password: password}

    new_device.reload

    expect(response.status).to eq 200
    expect(initial_device.user.username).to eq new_device.user.username
    expect(initial_device.user.id).to       eq new_device.user.id
  end

  it "logs in users who have no devices" do
    username = 'test'
    password = 'Password123'
    user = create(:user_without_device,
                  username: username,
                  email: 'test@test.com',
                  password: password)
    new_device = create(:device)

    expect(user.devices.count).to eq 0

    request.headers[:HTTP_DEVICE_ID] = new_device.device_id
    post :login, params: {email_or_username: username, password: password}

    new_device.reload

    expect(response.status).to eq 200
    expect(new_device.user.username).to           eq user.username
    expect(new_device.user.id).to                 eq user.id
    expect(new_device.user.devices.count).to  eq 1
  end

  it "does allow users to login if they're already logged in" do
    username = 'test'
    password = 'Password123'
    initial_device = create(:device_with_user, username: username,password: password)
    new_device = create(:device, user: create(:full_user))

    request.headers[:HTTP_DEVICE_ID] = new_device.device_id
    post :login, params: {:email_or_username => username, password: password}

    new_device.reload

    expect(response.status).to eq 422
    expect(initial_device.user.username).not_to eq new_device.user.username
    expect(initial_device.user.id).not_to       eq new_device.user.id
  end

  it "merges watch lists when a user successfully logs in" do
    password = "Password123"
    initial_device = create(:device_with_user, password: password)
    new_device = create(:device)

    existing_watches = [
      create(:watch, film: create(:film), user: new_device.user),
      create(:watch, film: create(:film), user: new_device.user),
      create(:watch, film: create(:film), user: new_device.user)
    ]

    request.headers[:HTTP_DEVICE_ID] = new_device.device_id
    post :login, params: {
      :email_or_username => initial_device.user.username,
      :password => password
    }

    new_device.reload

    expect(response.status).to eq 200
    expect(initial_device.user.username).to eq new_device.user.username
    expect(initial_device.user.id).to       eq new_device.user.id

    existing_watches.each do |w|
      w.reload
      expect(w.user.id).to eq initial_device.user.id
    end
  end

  it "favours the logging in user's watches over the current device's user's watches" do
    password = "Password123"
    initial_device = create(:device_with_user, password: password)
    new_device = create(:device)

    film_1 = create(:film)
    create(:watch, user: initial_device.user, film: film_1, rating: 5)
    create(:watch, user: new_device.user, film: film_1, rating: nil)

    film_2 = create(:film)
    create(:watch, user: initial_device.user, film: film_2, rating: nil)
    create(:watch, user: new_device.user, film: film_2, rating: 5)

    request.headers[:HTTP_DEVICE_ID] = new_device.device_id
    post :login, params: {
      :email_or_username => initial_device.user.username,
      :password => password
    }

    new_device.reload

    expect(response.status).to eq 200
    expect(initial_device.user.username).to eq new_device.user.username
    expect(initial_device.user.id).to       eq new_device.user.id
    expect(initial_device.user.watch_list_records[0].rating).to eq 5
    expect(initial_device.user.watch_list_records[1].rating).to eq nil
  end
end
