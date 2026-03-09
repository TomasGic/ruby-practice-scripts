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
    rescue StandardError => e
        puts "An error ocurred: #{e.message}"
    

# Design overview



# Domain rules



# Edge cases covered
