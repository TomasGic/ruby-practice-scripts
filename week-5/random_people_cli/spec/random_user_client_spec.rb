require_relative "spec_helper"
require "json"
# rspec spec/random_user_client_spec.rb
RSpec.describe RandomPeople::Clients::RandomUserClient do
  it "correctly fetches json payload from api using fake http client" do
    fixture_path = File.expand_path("fixtures/random_people.json", __dir__)
    json = File.read(fixture_path)
    http = FakeHttp.new(status: 200, body: json)
    client = described_class.new(http: http)
    payload = client.fetch(count: 1)
    puts payload["results"].class
    expect(payload["results"].length).to eq(1)
  end

  
  
end