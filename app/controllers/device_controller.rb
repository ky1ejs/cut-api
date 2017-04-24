class DeviceController < ApplicationController
  def set_push_token
    current_device = device
    current_device.push_token = params[:push_token]
    current_device.save!
    render status: 200
  end

  def remove_push_token
    current_device = device
    current_device.push_token = nil
    current_device.save!
  end
end
