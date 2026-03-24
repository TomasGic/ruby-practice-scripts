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
    context "when raw response contains data" do
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
    
    context "when raw response is empty" do
      it "fetches raw response from the client and returns an empty array without calling the mapper" do
        empty_response = { "results" => [] }
        expect(client).to receive(:fetch).and_return(empty_response)
        expect(mapper).not_to receive(:map_data)
        expect(service.execute).to eq([])
      end
    end

    context "when raw response is broken and/or results key is missing" do
      it "fetches the broken response from the client and returns an empty array" do
        broken_response = { "error" => "oops"}
        expect(client).to receive(:fetch).and_return(broken_response)
        expect(mapper).not_to receive(:map_data)
        expect(service.execute).to eq([])
      end
    end
  end
end
