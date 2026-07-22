module PaymentPipeline
  class NotificationService < BaseObserver
    FAILURE_EVENTS = [:validation_failed, :payment_failed]
    
    def update(event, data)
      return unless FAILURE_EVENTS.include?(event)
      super(event, data)
    end
  end
end