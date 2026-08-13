module Orders
  module Observable
    
    def observers
      @observers ||= []
    end
    
    def add_observer(observer)
      return if observers.include?(observer)
      unless observer.respond_to?(:update)
        raise InvalidObserverError, "Observer must respond to #update."
      end
      
      observers << observer
    end

    def notify_observers(event:, data:)
      observers.each do |observer|
        begin
          observer.update(event, data)
        rescue => e
          warn "Failed to update observer #{observer.class}: #{e.message}"
        end
      end
    end
  end
end