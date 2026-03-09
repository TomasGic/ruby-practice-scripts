require "minitest/autorun"
require_relative "../lib/dispatch"

class DispatcherTest < Minitest::Test
  
  def setup
    @mock_email = Minitest::Mock.new
    @mock_sms = Minitest::Mock.new

    @email_notification = Notification.new(recipient: "test@gmail.com", message: "Test", type: :email)
    @sms_notification = Notification.new(recipient: "+31619025555", message: "Hello", type: :sms)
    
  end
  def test_it_dispatches_email_notification_via_email_channel
    @mock_email.expect :supports?, true, [@email_notification]
    @mock_email.expect :send, true, [@email_notification]
    @mock_sms.expect :supports?, false, [@email_notification]
    
    dispatcher = Dispatcher.new(channels: [@mock_sms, @mock_email])
    dispatcher.dispatch(@email_notification)

    @mock_email.verify
    @mock_sms.verify

  end

  def test_it_dispatches_sms_notification_via_sms_channel
    @mock_email.expect :supports?, false, [@sms_notification]
    @mock_sms.expect :supports?, true, [@sms_notification]
    @mock_sms.expect :send, true, [@sms_notification]

    dispatcher = Dispatcher.new(channels: [@mock_email, @mock_sms])
    dispatcher.dispatch(@sms_notification)

    @mock_email.verify
    @mock_sms.verify
  end

  def test_it_raises_error_when_notification_type_is_unsupported
    unsupported_notification = Notification.new(recipient: "unknown", message: "Hello", type: :whatever)
    channels = [@mock_email, @mock_sms]
    dispatcher = Dispatcher.new(channels: channels)

    channels.each { |ch| ch.expect :supports?, false, [unsupported_notification] }
    error = assert_raises(UnsupportedNotificationError) { dispatcher.dispatch(unsupported_notification) }
    assert_equal "Notification type not supported", error.message
    channels.each(&:verify)
  end

  def test_dispatcher_records_successful_email_delivery
    dispatcher = Dispatcher.new(channels: [@mock_email])
    @mock_email.expect :supports?, true, [@email_notification]
    @mock_email.expect :send, true, [@email_notification]

    dispatcher.dispatch(@email_notification)

    record = dispatcher.logs[0]
    assert_equal 1, dispatcher.logs.size
    assert_equal @email_notification, record.notification
    assert_equal :success, record.status
    assert_nil record.error_message
  end

  def test_dispatcher_records_failed_email_delivery
    dispatcher = Dispatcher.new(channels: [@mock_email])
    @mock_email.expect :supports?, true, [@email_notification]
    @mock_email.expect :send, nil, [] do |n|
      assert_equal @email_notification, n
      raise "Delivery failed"
    end

    error = assert_raises(RuntimeError) { dispatcher.dispatch(@email_notification) }
    assert_equal "Delivery failed", error.message
    assert_equal 1, dispatcher.logs.size
  end

end

class EmailChannelTest < Minitest::Test 
  def setup
    @mock_client = Minitest::Mock.new
    @email_channel = EmailChannel.new(client: @mock_client)
  end

  def test_email_channel_sends_email_with_valid_email_address
    notification = Notification.new(recipient: "example@gmail.com", message: "Test", type: :email)

    @mock_client.expect(:send_email, true) do |args|
      args[:to] == notification.recipient && args[:body] == notification.message
    end
    @email_channel.send(notification)
    @mock_client.verify
  end

  def test_error_is_raised_when_email_address_is_invalid
    notification = Notification.new(recipient: "examplegmail.com", message: "Test", type: :email)
    assert_raises(InvalidRecipientError) { @email_channel.send(notification) }
  end
end

class SmsChannelTest < Minitest::Test
  def setup
    @mock_client = Minitest::Mock.new
    @sms_channel = SmsChannel.new(client: @mock_client)
  end
  def test_sms_channel_sends_notification_with_valid_phone_number
    notification = Notification.new(recipient: "+31619222555", message: "Test", type: :sms)
    @mock_client.expect(:send_sms, true) do |args|
      args[:to] == notification.recipient && args[:body] == notification.message
    end
    @sms_channel.send(notification)
    @mock_client.verify
  end

  def test_error_is_raised_when_phone_number_invalid
    notification = Notification.new(recipient: "1234", message: "Test", type: :sms)
    assert_raises(InvalidRecipientError) { @sms_channel.send(notification) }
  end
end

class DeliveryRecordTest < Minitest::Test 
  def setup
    @notification = Notification.new(recipient: "example@gmail.com", message: "Test", type: :email)
  end

  def test_record_initializes_with_correct_attributes
    record = DeliveryRecord.new(notification: @notification, status: :success)

    assert_equal @notification, record.notification
    assert_equal :success, record.status
    assert_nil record.error_message
  end
end

