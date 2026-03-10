class Dispatcher
  attr_reader :channels, :logs
  def initialize(channels:)
    @channels = channels
    @logs = []
  end

  def dispatch(notification)
    channel = @channels.find { |ch| ch.supports?(notification)} 
    if channel
      begin
        if notification.message.nil? || notification.message.strip.empty?
          raise EmptyMessageError, "Message cannot be empty"
        else
          success_message = channel.send(notification)
          record_delivery(notification: notification, status: :success, error_message: nil)
          success_message
        end
      rescue => e
        record_delivery(notification: notification, status: :failed, error_message: e.message)
        raise e
      end
    else 
      raise UnsupportedNotificationError, "Notification type not supported"
    end
  end

  private
  def record_delivery(notification:, status:, error_message:)
    delivery_record = DeliveryRecord.new(notification: notification, status: status, error_message: error_message)
    @logs << delivery_record
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
  MAX_LENGTH_MESSAGE = 160
  
  def initialize(client:)
    @client = client
  end

  def supports?(notification)
    notification.type == :sms
  end

  def send(notification)
    validate_phone_number!(notification.recipient)
    validate_length!(notification.message)
    @client.send_sms(to: notification.recipient, body: notification.message)
    
    "Notification has been sent!\n#{notification.message}."
  end

  private
  
  def validate_phone_number!(phone_number)
    raise InvalidRecipientError, "Invalid phone number" unless phone_number =~ PHONE_NUMBER_PATTERN
  end

  def validate_length!(message)
    raise MessageTooLongError unless message.length <= MAX_LENGTH_MESSAGE 
  end
end

class DeliveryRecord 
  attr_reader :notification, :status, :error_message
  def initialize(notification:, status:, error_message: nil)
    @notification = notification
    @status = status
    @error_message = error_message
  end
end

class UnsupportedNotificationError < StandardError; end
class InvalidRecipientError < StandardError; end
class MessageTooLongError < StandardError; end
class EmptyMessageError < StandardError; end



