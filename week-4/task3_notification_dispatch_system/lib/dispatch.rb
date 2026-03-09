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
  attr_reader :recipient, :message, :type
  def initialize(recipient:, message:, type:)
    @recipient = recipient
    @message = message
    @type = type
  end
end

class EmailChannel

  EMAIL_PATTERN = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)+\z/i
  
  def initialize(client:)
    @client = client
  end

  def supports?(notification)
    notification.type == :email
  end

  def send(notification)
    validate_email!(notification.recipient)
    @client.send_email(to: notification.recipient, body: notification.message)
    
    "Notification has been sent!\n#{notification.message}."
  end

  private 

  def validate_email!(email_address)
    raise InvalidRecipientError, "Invalid email address" unless email_address =~ EMAIL_PATTERN
  end
end

class SmsChannel

  PHONE_NUMBER_PATTERN = /\A\+?[1-9]\d{7,14}\z/
  
  def initialize(client:)
    @client = client
  end

  def supports?(notification)
    notification.type == :sms
  end

  def send(notification)
    validate_phone_number!(notification.recipient)
    @client.send_sms(to: notification.recipient, body: notification.message)
    
    "Notification has been sent!\n#{notification.message}."
  end

  private
  def validate_phone_number!(phone_number)
    raise InvalidRecipientError, "Invalid phone number" unless phone_number =~ PHONE_NUMBER_PATTERN
  end
end

class UnsupportedNotificationError < StandardError; end
class InvalidRecipientError < StandardError; end


