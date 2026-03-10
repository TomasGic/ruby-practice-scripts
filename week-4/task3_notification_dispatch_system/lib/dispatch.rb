class Dispatcher
  attr_reader :channels, :logs
  def initialize(channels:)
    @channels = channels # channels should be an array of objects that respond to supports? and send
    @logs = []
  end

  def dispatch(notification)
    
    # find the first channel that supports given notification type
    channel = @channels.find { |ch| ch.supports?(notification)} 
    if channel
      begin
        if notification.message.nil? || notification.message.strip.empty?
          raise EmptyMessageError, "Message cannot be empty"
        else
          success_message = channel.send(notification)

          # record successful delivery attempt into the logs array
          record_delivery(notification: notification, status: :success, error_message: nil)
          success_message
        end
      rescue => e

        # record a failed delivery attempt into the logs array
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
  EMAIL_REGEX_PATTERN = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)+\z/i
  
  # channel expects a client which in a real app is responsible for the actual
  # notification delivery. In our system we do not use a real client. 
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
    raise InvalidRecipientError, "Invalid email address" unless email_address =~ EMAIL_REGEX_PATTERN
  end
end

class SmsChannel
  PHONE_NUMBER_PATTERN = /\A\+?\d{8,15}\z/ # Phone number should have minimum 8 and max 15 digits
  MAX_LENGTH_MESSAGE = 160 # Sms message length should not exceed 160 characters
  
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

# Represents a record of both a successful and failed delivery attempts
class DeliveryRecord 
  attr_reader :notification, :status, :error_message
  def initialize(notification:, status:, error_message: nil)
    @notification = notification
    @status = status
    @error_message = error_message
  end
end

# Custom error classes
class UnsupportedNotificationError < StandardError; end
class InvalidRecipientError < StandardError; end
class MessageTooLongError < StandardError; end
class EmptyMessageError < StandardError; end



