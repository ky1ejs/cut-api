require 'rails_helper'

RSpec.describe DeviceController, type: :controller do
  it "should set push tokens" do
    d = create(:device)

    token = "12312312sdadas123123dsad"

    request.headers[:HTTP_DEVICE_ID] = "#{d.platform}_#{d.id}"
    post :set_push_token, params: {:push_token => token}

    d.reload

    expect(d.push_token).to eq token
  end

  it "should remove push tokens" do
    d = create(:device_with_push_token)

    request.headers[:HTTP_DEVICE_ID] = "#{d.platform}_#{d.id}"
    delete :remove_push_token

    d.reload

    expect(d.push_token).to eq nil
  end
end
