require "rails_helper"

RSpec.describe UserSerializer do
  it 'correctly serializes a user' do
    email = 'test@test.com'
    username = 'test'
    u = create(:full_user, email: email, username: username)

    hash = UserSerializer.new(u, scope: u.devices.first).serializable_hash

    expect(hash[:email]).to eq email
    expect(hash[:username]).to eq username
    expect(hash[:is_full_user]).to eq true
    expect(hash[:follower_count]).to eq 0
    expect(hash[:following_count]).to eq 0

    hashed_email = Digest::MD5.hexdigest(email)
    gravatar_url = "https://www.gravatar.com/avatar/#{hashed_email}?d=404"
    expect(hash[:profile_image]).to eq gravatar_url
  end

  it "should never return the users password in json" do
    u = create(:full_user)
    hashed_email = Digest::MD5.hexdigest(u.email)
    gravatar_url = "https://www.gravatar.com/avatar/#{hashed_email}?d=404"
    stub_request(:get, gravatar_url).to_return(status: 404)

    hash = UserSerializer.new(u).serializable_hash
    expect(hash.keys).not_to include :hashed_password, 'hashed_password'
    expect(hash.keys).not_to include :password, 'password'
    expect(hash.keys).not_to include :salt, 'salt'
  end

  it "serialises how following and followers count" do
    u = create(:full_user)

    (0..2).each do
      user = create(:full_user)
      u.followers.push user
      u.following.push user
    end

    hash = UserSerializer.new(u).serializable_hash

    expect(hash[:following_count]).to eq 3
    expect(hash[:follower_count]).to eq 3
  end
end
