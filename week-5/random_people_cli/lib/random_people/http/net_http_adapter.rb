module RandomPeople
  module HTTP
    class FakeHttp
      attr_reader :seen_urls
      def initialize(status:, body:)
        @status = status
        @body = body
        @seen_urls = []
      end

      def get(url, headers: {})
        @seen_urls << url
        RandomPeople::HTTP::Response.new(status: @status, body: @body)
      end
    end

    class RealHttp
      def get(url, headers: {})
        uri = URI(url)
        req = Net::HTTP::Get.new(uri)
        headers.each { |k, v| req[k] = v }

        res = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https") do |http|
          http.request(req)
        end
        RandomPeople::HTTP::Response.new(status: res.code.to_i, body: res.body.to_s)
      end
    end
      
  end
end
    
  

