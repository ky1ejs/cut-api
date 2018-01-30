class ApiController < ActionController::API
  serialization_scope :device

  def device
    device_id = request.headers[:HTTP_DEVICE_ID]

    return if device_id.nil?
    return @device if @device&.device_id&.downcase == device_id.downcase

    regex = /^(?<platform>[a-z]*)_(?<id>[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12})$/i
    device_id = device_id.match regex

    @device = Device.find_or_create_by(id: device_id[:id].downcase, platform: device_id[:platform].downcase)
    @device.app_id = request.headers[:HTTP_APP_ID]
    @device.is_dev_device = request.headers[:HTTP_IS_DEV_DEVICE] == 'true'
    @device.save!

    @device.user.last_seen = Time.now
    @device.user.save!
    @device
  end

  def queried_user
    User.find_by(username: params[:username]) || device.user
  end
end