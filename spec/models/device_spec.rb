require "rails_helper"

RSpec.describe Device, :type => :model do
  it "saves given UUID" do
    uuid = "2a2096ff-ed6c-450d-bdb4-98757793fdeb"
    d = Device.new
    d.id = uuid
    d.platform = :ios

    expect(d.new_record?).to eq true
    expect(d.valid?).to eq true

    d.save

    expect(d.new_record?).to eq false
    expect(d.id).to eq uuid
  end

  it 'allows changing of user' do
    d = create(:device)

    expect(d.user).not_to eq nil

    new_user = create(:user_without_device)
    d.user = new_user
    d.save!

    expect(d.user.id).to eq new_user.id
    expect(new_user.devices.count).to eq 1
    expect(new_user.devices.first.id).to eq d.id
  end
end
