require "rails_helper"

RSpec.describe User, :type => :model do
  it "finds profile images on Gravatar" do
    user_with_gravatar = "kylejmcalpine@gmail.com"

    u = User.new
    u.email = user_with_gravatar
    u.username = "kylejm"
    u.hashed_password = "test"
    u.save!

    json = u.as_json

    expect(json['profile_image']).to eq 'https://www.gravatar.com/avatar/b194dda96ad4d556c81977b2c1d10a9f?d=404'

    u.destroy!
  end

  it "handles case where user does not have gravatar" do
    user_without_gravatar = "e-m-a-i-l@not_in.use"

    u = User.new
    u.email = user_without_gravatar
    u.username = "kylejm"
    u.hashed_password = "test"
    u.save!

    json = u.as_json

    expect(json['profile_image']).to eq nil

    u.destroy!
  end
end
