module Shipping
  module Loggable
    def logs
      @logs ||= []
    end

    def log(entry)
      logs << entry
    end
  end
end