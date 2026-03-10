## Notification dispatch system

A Ruby implentation of a small notification dispatch system that models the delivery of notification requests via multiple channels (Email, Sms). The project was built with TDD approach in mind.

# Running tests

from this folder run the following command in your terminal:


    test/dispatch_test.rb

# Example usage 

    email_client = SendGridClient.new(api_key: "SG.xxx")
    sms_client = TwilioClient.new(account_sid: "AC.xxx")
    channels = [
        EmailChannel.new(client: email_client), 
        SmsChannel.new(client: sms_client)
    ]

    notification = Notification.new(recipient: "example@gmail.com", message: "Test", type: :email)

    dispatcher = Dispatcher.new(channels: channels)

    begin
        result = dispatcher.dispatch(notification)
        puts result
    rescue => e
        puts "An error ocurred: #{e.message}"
    
    failed_logs = dispatcher.logs.select { |log| log.status == :failed }
    failed_logs.each do |log|
        puts "--- Failure Details ---"
        puts "Recipient: #{log.notification.recipient}"
        puts "Error:     #{log.error_message}"
        puts "Type:      #{log.notification.type}"
    end

# Design overview
- Notification - represents the request object that holds the recipient, message and type data. 

- Dispatcher - represents the core service that orchestrates the delivery of notification requests. It accepts the notification object and selects the appropriate channel that supports the delivery of that notification type. It records both successful and failed delivery attempts in a DeliveryRecord object.

- Channels - handle the actual delivery of notifications. The logic of whether a particular notification type is supported by each channel is implemented within the channel class. The project contains EmailChannel and SmsChannel. 

- DeliveryRecord - holds the logs of successful and failed notification delivery attempts.

# Domain rules
- Message in both email and sms notification objects cannot be empty or just whitespace(EmptyMessageError will be raised and dispatcher will not attempt a delivery)
- Notification of unsupported type will not be passed onto a channel for delivery (UnsupportedNotificationError will be raised)
- Email rules - Recipient in notification of type email has to be a valid email address. This is verified using a regex pattern matching. InvalidRecipientError is raised for invalid email addresses.
- Sms rules - Recipient in notification of type sms has to be a valid phone number (8-15 digits, optional + prefix). Message length cannot exceed 160 characters.


# Edge cases covered
- invalid email address and phone number will raise an error. 
- empty message will raise an error
- attempting a delivery of sms notification where the message exceeds 160 characters will raise an error.
- attempting a delivery of notification of unsupported type will raise an error