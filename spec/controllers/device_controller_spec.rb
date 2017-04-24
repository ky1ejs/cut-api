require 'rails_helper'

RSpec.describe DeviceController, type: :controller do
  before(:each) do
    @device = Device.new
    @device.platform = :ios
    @device.save!
  end

  after(:each) do
    @device.destroy!
  end

  it "should set push tokens" do
    token = "12312312sdadas123123dsad"

    request.headers[:HTTP_DEVICE_ID] = "#{@device.platform}_#{@device.id}"
    post :set_push_token, params: {:push_token => token}

    @device.reload

    expect(@device.push_token).to eq token
  end

  it "should remove push tokens" do
    @device.push_token = "12321321321esadsa12312esadsa"
    @device.save!

    request.headers[:HTTP_DEVICE_ID] = "#{@device.platform}_#{@device.id}"
    delete :remove_push_token

    @device.reload

    expect(@device.push_token).to eq nil
  end
end
