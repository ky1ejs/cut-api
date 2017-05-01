require "rails_helper"

RSpec.describe User, :type => :model do
  it "finds profile images on Gravatar" do
    u = create(:full_user, email: "kylejmcalpine@gmail.com")
    expect(u.as_json['profile_image']).to eq 'https://www.gravatar.com/avatar/b194dda96ad4d556c81977b2c1d10a9f?d=404'
  end

  it "handles case where user does not have gravatar" do
    u = create(:full_user, email: "e-m-a-i-l@not-in.us")
    expect(u.as_json['profile_image']).to eq nil
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

  it "should never return the users password in json" do
    u = create(:full_user)
    hashed_email = Digest::MD5.hexdigest(u.email)
    gravatar_url = "https://www.gravatar.com/avatar/#{hashed_email}?d=404"
    stub_request(:get, gravatar_url).to_return(status: 404)

    json = u.as_json
    expect(json[:hashed_password]).to eq nil
    expect(json[:salt]).to eq nil
    expect(json[:password]).to eq nil
  end
end
