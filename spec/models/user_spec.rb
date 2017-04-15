require "rails_helper"

RSpec.describe User, :type => :model do
  it "finds profile images on Gravatar" do
    user_with_gravatar = "kylejmcalpine@gmail.com"

    u = User.new
    u.email = user_with_gravatar
    u.username = "kylejm"
    u.password = "Secure12345"
    u.save!

    json = u.as_json

    expect(json['profile_image']).to eq 'https://www.gravatar.com/avatar/b194dda96ad4d556c81977b2c1d10a9f?d=404'

    u.destroy!
  end

  it "handles case where user does not have gravatar" do
    user_without_gravatar = "e-m-a-i-l@not-in.us"

    u = User.new
    u.email = user_without_gravatar
    u.username = "kylejm"
    u.password = "Secure12345"
    u.save!

    json = u.as_json

    expect(json['profile_image']).to eq nil

    u.destroy!
  end

  it "should encrypt the user's password" do
    password = "Secure12345"

    u = User.new
    u.email = "test@test.com"
    u.username = "kylejm"
    u.password = password
    u.save!

    expect(u.password).to eq nil
    expect(u.check_password(password)).to eq true

    u.destroy!
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
    u = User.new
    u.email = "test@test.com"
    u.password = "Secure12345"
    u.username  = "test"
    u.save!

    expect(u.id).not_to eq nil

    last_seen = Time.now
    u.last_seen = last_seen
    u.save!

    expect(u.last_seen).to eq last_seen

    u.destroy!
  end
end
