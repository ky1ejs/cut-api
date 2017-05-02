class NotificationService
  def self.publish(message)
    exchange = channel.fanout('notification.exchange', durable: true)
    exchange.publish({'message' => message, 'is_dev_token' => true}.to_json)
  end

  def self.channel
    @channel ||= connection.create_channel
  end

  def self.connection
    @connection ||= Bunny.new.tap { |c| c.start }
  end
end
