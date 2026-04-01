require "json"

module RandomPeople
  module Clients
    class RandomUserClient
      BASE_URL = "https://randomuser.me/api"
      
      def initialize(http:)
        @http = http
      end

      def fetch(count:)
        url = "#{BASE_URL}/?results=#{count}"
        res = @http.get(url, headers: { "Accept" => "application/json" })
        
        unless res.success?
          raise ApiError, "API request failed with status #{res.status}."
        end
        
        JSON.parse(res.body)
      rescue JSON::ParserError
        raise ApiError, "API returned invalid JSON."
      end
    end
  end
end