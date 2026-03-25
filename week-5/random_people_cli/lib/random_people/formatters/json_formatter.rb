require "json"

module RandomPeople
  module Formatters
    class JsonFormatter
      

      def format(users)
        return "no results found" if users.empty? 
        users_as_hashes = users.map(&:to_h)
        JSON.pretty_generate(users_as_hashes)
      end
      
    end
  end
end