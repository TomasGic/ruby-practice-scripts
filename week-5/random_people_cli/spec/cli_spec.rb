# rspec spec/cli_spec.rb

RSpec.describe RandomPeople::Cli do
  let(:service) { instance_double(RandomPeople::PeopleService) }
  let(:user) do 
    RandomPeople::User.new(
      first_name: "Tomas", 
      last_name: "Gic", 
      email: "test@example.com",
      age: 30,
      country: "Slovakia"
  ) 
  end
  let(:users) { [user] }
  let(:table_formatter) { instance_double(RandomPeople::Formatters::TableFormatter) }
  let(:json_formatter) { instance_double(RandomPeople::Formatters::JsonFormatter) }
  
  describe "#run"
    it "calls the service with default count of 5" do
      expect(service).to receive(:execute).with(count: 5).and_return(users)

      RandomPeople::Cli.new(service: service).run([])
    end

    it "calls the service with the count specified by the user" do
      expect(service).to receive(:execute).with(count: 6).and_return(users)

      RandomPeople::Cli.new(service: service).run(["--count", "6"])
    end

    it "calls the table formatter when no format is specified by the user" do
      allow(service).to receive(:execute).with(count: 5).and_return(users)
      expect(RandomPeople::Formatters::TableFormatter).to receive(:new).and_return(table_formatter)
      expect(table_formatter).to receive(:format).with(users)
      expect(json_formatter).not_to receive(:format)

      RandomPeople::Cli.new(service: service).run([])
    end

    it "calls the json formatter when json format is specified by the user" do
      allow(service).to receive(:execute).with(count: 5).and_return(users)
      expect(RandomPeople::Formatters::JsonFormatter).to receive(:new).and_return(json_formatter)
      expect(json_formatter).to receive(:format).with(users)
      expect(table_formatter).not_to receive(:format)

      RandomPeople::Cli.new(service: service).run(["--format", "json"])
    end

    it "raises custom error when unsupported format type is passed" do
      expect(service).not_to receive(:execute)
      expect {
        RandomPeople::Cli.new(service: service).run(["--format", "csv"]).to raise_error(
          RandomPeople::UnsupportedFormatError, /Format csv is not supported/
        )
      }
    end
end