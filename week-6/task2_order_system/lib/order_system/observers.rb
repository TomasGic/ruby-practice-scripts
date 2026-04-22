module Orders
  class BaseObserver
    attr_reader :events

    def initialize
      @events = []
    end

    def update(event, data)
      @events << {event: event, data: data}
    end
  end

  class EmailNotifier < BaseObserver; end
  class AnalyticsTracker < BaseObserver; end
end