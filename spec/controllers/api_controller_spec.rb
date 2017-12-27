require "rails_helper"

RSpec.describe ApiController, :type => :controller do
  it "saves given UUID and type" do
    platform = 'ios'
    uuid = '2a2096ff-ed6c-450d-bdb4-98757793fdeb'

    @request.env['HTTP_DEVICE_ID'] = "#{platform}_#{uuid}"

    d = subject.device

    expect(d.id).to eq uuid
    expect(d.platform).to eq platform
    expect(d.new_record?).to eq false
  end

  it 'saves the passed App ID' do
    platform = 'ios'
    uuid = '2a2096ff-ed6c-450d-bdb4-98757793fdeb'
    app_id = 'cut.watch'

    @request.env['HTTP_DEVICE_ID'] = "#{platform}_#{uuid}"
    @request.env['HTTP_APP_ID'] = app_id

    d = subject.device

    expect(d.id).to eq uuid
    expect(d.platform).to eq platform
    expect(d.app_id).to eq app_id
    expect(d.new_record?).to eq false
  end

  it 'doesn\'t persist devices across calls' do
    d1 = create(:device)
    @request.env['HTTP_DEVICE_ID'] = d1.device_id
    expect(subject.device.id).to eq d1.id
    expect(subject.device.platform).to eq d1.platform

    d2 = create(:device)
    @request.env['HTTP_DEVICE_ID'] = d2.device_id
    expect(subject.device.id).to eq d2.id
    expect(subject.device.platform).to eq d2.platform
  end

  it 'retrieves an existing device if with an upcase ID' do
    d = create(:device)

    @request.env['HTTP_DEVICE_ID'] = d.device_id.upcase

    expect(d.id).to       eq subject.device.id
    expect(d.platform).to eq subject.device.platform
  end

  it 'persists the current device throughout the request' do
    d = create(:device)

    @request.env['HTTP_DEVICE_ID'] = d.device_id

    first_call = subject.device
    second_call = subject.device

    expect(first_call.object_id).to eq second_call.object_id
  end

end
