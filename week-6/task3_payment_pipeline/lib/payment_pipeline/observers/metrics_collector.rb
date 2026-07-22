module PaymentPipeline
  class MetricsCollector < BaseObserver
    attr_reader :successful_payments, :failed_payments
    
    def initialize
      super
      @successful_payments = 0
      @failed_payments = 0
    end

    def update(event, data)
      super(event, data)
      if event.to_s.include?("failed")
        @failed_payments += 1
      elsif event.to_s.include?("passed") || event.to_s.include?("succeeded")
        @successful_payments += 1
      end
    end
  end
end