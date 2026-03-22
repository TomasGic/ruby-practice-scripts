class FakeHttp
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