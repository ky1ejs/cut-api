require 'rails_helper'

RSpec.describe Follow, type: :model do
  it "cannot be saved if the follower and following are the same" do
    u = create(:full_user)

    f = Follow.new
    f.following = u
    f.follower = u

    expect { f.save! }.to raise_exception(ActiveRecord::RecordInvalid)
  end

  it "cannot be saved if both users are full users" do
    not_full_user = create(:user)
    full_user = create(:full_user)

    f = Follow.new
    f.following = not_full_user
    f.follower = full_user

    expect { f.save! }.to raise_exception(ActiveRecord::RecordInvalid)

    f = Follow.new
    f.following = full_user
    f.follower = not_full_user

    expect { f.save! }.to raise_exception(ActiveRecord::RecordInvalid)
  end

  it "saves if both users are full users" do
    u1 = create(:full_user)
    u2 = create(:full_user)

    f = Follow.new
    f.following = u1
    f.follower = u2
    f.save!

    expect(f.id).to_not eq nil
  end
end
