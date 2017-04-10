require "rails_helper"

RSpec.describe ApplicationController, :type => :controller do
  controller do
    # def device
    #   subject.device
    # end
  end

  it "saves given UUID and type" do
    routes.draw { get "device" => "anonymous#device" }

    type = 'ios'
    uuid = '2a2096ff-ed6c-450d-bdb4-98757793fdeb'

    # expect(Device.find(uuid).nil?).to eq true

    get :device, :HTTP_DEVICE_ID => "#{type}_#{uuid}"

    d = Device.find_by(uuid: uuid)

    expect(d.id).to eq uuid
    expect(d.type).to eq type
  end
end
