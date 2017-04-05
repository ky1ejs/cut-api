class DeviceController < ApplicationController
  def register_device
    d = Device.new
    d.id = params[:device_id]
    d.type = params[:type]
    d.save!
  end
end
