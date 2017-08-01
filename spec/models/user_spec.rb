require "rails_helper"

RSpec.describe User, :type => :model do
  it "finds profile images on Gravatar" do
    u = create(:full_user)
    hashed_email = Digest::MD5.hexdigest(u.email)
    gravatar_url = "https://www.gravatar.com/avatar/#{hashed_email}?d=404"

    stub_request(:get, gravatar_url).to_return(status: 200)

    expect(u.profile_image_url).to eq gravatar_url
  end

  it "handles case where user does not have gravatar" do
    u = create(:full_user)
    hashed_email = Digest::MD5.hexdigest(u.email)
    gravatar_url = "https://www.gravatar.com/avatar/#{hashed_email}?d=404"

    stub_request(:get, gravatar_url).to_return(status: 404)

    expect(u.profile_image_url).to eq nil
  end

  it "should encrypt the user's password" do
    password = "Secure12345"
    u = create(:full_user, password: password)
    expect(u.password).to eq nil
    expect(u.check_password(password)).to eq true
  end

  it "should be able to save annonymously" do
    u = User.new
    u.save!
    expect(u.id).not_to eq nil
    u.destroy!
  end

  it "should be able to update the last time we saw an annonymous user" do
    u = User.new
    u.save!

    expect(u.id).not_to eq nil

    last_seen = Time.now
    u.last_seen = last_seen
    u.save!

    expect(u.last_seen).to eq last_seen

    u.destroy!
  end

  it "should be able to update the last time we saw a full user" do
    u = create(:full_user)

    expect(u.id).not_to eq nil

    last_seen = Time.now
    u.last_seen = last_seen
    u.save!

    expect(u.last_seen).to eq last_seen

    u.destroy!
  end

  it "adds followers via the 'followers' attribute" do
    u = create(:full_user)
    f = create(:full_user)

    u.followers = [f]

    expect(f.following.count).to eq 1
    expect(f.following.first.id).to eq u.id

    u.destroy!
    f.destroy!

    u = create(:full_user)
    f = [create(:full_user), create(:full_user), create(:full_user)]

    u.followers = f

    expect(f.first.following.count).to eq 1
    expect(u.followers.count).to eq 3
    expect(f.first.following.first.id).to eq u.id
  end

  it "adds followers via the 'following' attribute" do
    u = create(:full_user)
    f = create(:full_user)

    u.following = [f]

    expect(f.followers.count).to eq 1
    expect(f.followers.first.id).to eq u.id

    u.destroy!
    f.destroy!

    u = create(:full_user)
    f = [create(:full_user), create(:full_user), create(:full_user)]

    u.following = f

    expect(u.following.count).to eq 3
    expect(f.first.followers.count).to eq 1
    expect(f.first.followers.first.id).to eq u.id
  end
end
