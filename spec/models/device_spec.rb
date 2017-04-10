require "rails_helper"

RSpec.describe User, :type => :model do
  it "saves given UUID" do
    type = :ios
    uuid = "2a2096ff-ed6c-450d-bdb4-98757793fdeb"
    d = Device.new
    d.id = uuid
    d.type = type

    expect(d.new_record?).to eq true
    expect(d.valid?).to eq true

    d.save

    expect(d.new_record?).to eq false
    expect(d.id).to eq uuid
  end
end
