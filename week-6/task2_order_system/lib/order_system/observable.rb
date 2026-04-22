module Orders
  module Observable
    attr_reader :observers
    
    def add_observer(observer)
      @observers ||= []
      @observers << observer
    end

    def notify_observers(event:, data:)
      (@observers || []).each do |obs|
        begin
          obs.update(event, data)
        rescue => e
          warn "Failed to update observer #{obs.class}: #{e.message}"
        end
      end
    end
  end
end