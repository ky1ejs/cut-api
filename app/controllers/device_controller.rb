class DeviceController < ApiController
  def set_push_token
    device.push_token = params[:push_token]
    device.save!
    render status: 200
  end

  def remove_push_token
    device.push_token = nil
    device.save!
  end
end
