module PaymentPipeline
  class BaseObserver
    attr_reader :events

    def initialize
      @events = []
    end

    def update(event, data)
      @events << {event: event, data: data}
    end
  end
end