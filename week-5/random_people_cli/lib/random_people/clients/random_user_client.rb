require "json"

module RandomPeople
  module Clients
    class RandomUserClient
      BASE_URL = "https://randomuser.me/api/"
      
      def initialize(http:)
        @http = http
      end

      def fetch(count:)
        url = "#{BASE_URL}/?results=#{count}"
        res = @http.get(url, headers: { "Accept" => "application/json" })
        JSON.parse(res.body)
      end
    end
  end
end