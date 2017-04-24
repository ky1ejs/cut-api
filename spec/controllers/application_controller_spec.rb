require "rails_helper"

RSpec.describe ApplicationController, :type => :controller do
  it "saves given UUID and type" do
    platform = 'ios'
    uuid = '2a2096ff-ed6c-450d-bdb4-98757793fdeb'

    # expect(Device.find(uuid).nil?).to eq true

    @request.env['HTTP_DEVICE_ID'] = "#{platform}_#{uuid}"

    d = subject.device

    expect(d.id).to eq uuid
    expect(d.platform).to eq platform
    expect(d.new_record?).to eq false

    d.destroy!
  end
end
