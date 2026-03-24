# rspec spec/people_service_spec.rb
RSpec.describe RandomPeople::PeopleService do
  let(:client) { instance_double("RandomPeople::Clients::RandomUserClient") }
  let(:mapper) { class_double("RandomPeople::UserMapper") }
  let(:service) { described_class.new(client: client, mapper: mapper) }
  let(:raw_response) do
    {
      "results" => [
        { "name" => { "first" => "Tomas"} },
        { "name" => { "first" => "Lukas"}}
      ]
    }
  end

  describe "#execute" do
    it "fetches raw response from the client and maps the response into array of user objects " do
      num_users = raw_response["results"].size
      fake_user = instance_double("RandomPeople::User")
      
      expect(client).to receive(:fetch).with(count:2).and_return(raw_response)
      expect(mapper).to receive(:map_data).exactly(num_users).times.and_return(fake_user)
      
      results = service.execute
      
      expect(results).to be_an(Array)
      expect(results.size).to eq(num_users)
      expect(results.all? { |user| user == fake_user }).to eq(true)
    end
  end
end
