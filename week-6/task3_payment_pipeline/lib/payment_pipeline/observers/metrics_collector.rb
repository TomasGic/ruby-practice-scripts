module PaymentPipeline
  class MetricsCollector < BaseObserver

    SUCCESS_EVENTS = [:payment_succeeded].freeze
    FAILURE_EVENTS = [:validation_failed, :payment_failed]
    
    attr_reader :success_count, :failure_count
    
    def initialize
      super
      @success_count = 0
      @failure_count = 0
    end

    def update(event, data)
      super(event, data)
      @failure_count += 1 if FAILURE_EVENTS.include?(event)
      @success_count += 1 if SUCCESS_EVENTS.include?(event)
    end
  end
end