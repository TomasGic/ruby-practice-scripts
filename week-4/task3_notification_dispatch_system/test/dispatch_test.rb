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
    assert_raises(UnsupportedNotificationError) { dispatcher.dispatch(unsupported_notification) }
    channels.each(&:verify)
  end
end