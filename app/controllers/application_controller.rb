class ApplicationController < ActionController::API
  def device
    regex = /^(?<type>[a-z]*)_(?<id>[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12})$/i
    device_id = request.headers[:HTTP_DEVICE_ID].match regex
    Device.find_or_create_by(id: device_id[:id], type: device_id[:type])
  end
end
