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
    @connection ||= Bunny.new.tap { |c| c.start }
  end
end
