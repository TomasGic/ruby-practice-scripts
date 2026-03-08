class Dispatcher
  def initialize(channels:)
    @channels = channels
  end

  def dispatch(notification)
    channel = @channels.find { |ch| ch.supports?(notification)} 
    if channel
      channel.send(notification)
    else 
      raise UnsupportedNotificationError, "Notification type not supported"
    end
  end
end

class Notification
  def initialize(recipient:, message:, type:)
    @recipient = recipient,
    @message = message
    @type = type
  end
end

class EmailChannel
  def initialize(client:)
    @client = client
  end

  def supports?(notification)
    notification.type == :email
  end

  def send(notification)
    notification.message
  end
end

class SmsChannel
  def initialize(client:)
    @client = client
  end

  def supports?(notification)
    notification.type == :sms
  end

  def send(notification)
    notification.message
  end
end

class UnsupportedNotificationError < StandardError; end


