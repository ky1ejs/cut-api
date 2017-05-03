class NotificationService
  def self.publish(message, device)
    return if device.push_token.nil?

    payload = {
      'message' => message,
      'is_dev_token' => device.is_dev_device,
      'token' => device.push_token
    }
    exchange = channel.fanout('notification.exchange', durable: true)
    exchange.publish(payload.to_json)
  end

  def self.channel
    @channel ||= connection.create_channel
  end

  def self.connection
    @connection ||= Bunny.new(
    {
      :host      => RABBIT_CONFIG[:host],
      :port      => 5672,
      :ssl       => false,
      :vhost     => "/",
      :user      => RABBIT_CONFIG[:user],
      :pass      => RABBIT_CONFIG[:password],
      :heartbeat => :server, # will use RabbitMQ setting
      :frame_max => 131072,
      :auth_mechanism => "PLAIN"
    }).tap { |c| c.start }
  end
end
