module PaymentPipeline
  class MetricsCollector < BaseObserver
    attr_reader :success_count, :failure_count
    
    def initialize
      super
      @success_count = 0
      @failure_count = 0
    end

    def update(event, data)
      super(event, data)
      if event.to_s.include?("failed")
        @failure_count += 1
      elsif event.to_s.include?("passed") || event.to_s.include?("succeeded")
        @success_count += 1
      end
    end
  end
end