require "json"
# rspec spec/random_user_client_spec.rb
RSpec.describe RandomPeople::Clients::RandomUserClient do
  it "correctly fetches json payload from api using fake http client" do
    fixture_path = File.expand_path("fixtures/random_people.json", __dir__)
    json = File.read(fixture_path)
    http = FakeHttp.new(status: 200, body: json)
    client = described_class.new(http: http)
    payload = client.fetch(count: 1)
    
    expect(payload["results"].length).to eq(1)
    expect(payload["results"].first["name"]["first"]).to eq("Jennie")
    expect(payload["results"].first["name"]["last"]).to eq("Nichols")
    expect(http.seen_urls.first).to include("results=1")
  end

  it "raises api error when response code is 500 (server error)" do
    http = FakeHttp.new(status: 500, body: "oops")
    client = described_class.new(http: http)

    expect { client.fetch(count: 1) }.to raise_error("api error")
  end

  it "raises json parser error when json is invalid" do
    http = FakeHttp.new(status: 200, body: "not json}")
    client = described_class.new(http: http)

    expect { client.fetch(count: 1) }.to raise_error(JSON::ParserError)
  end

  
  
end