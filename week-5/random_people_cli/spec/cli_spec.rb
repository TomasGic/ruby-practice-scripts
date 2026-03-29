# rspec spec/cli_spec.rb

RSpec.describe RandomPeople::Cli do
  let(:service) { instance_double(RandomPeople::PeopleService) }
  let(:cli) { RandomPeople::Cli.new(service: service) }
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

      cli.run([])
    end

    it "calls the service with the count specified by the user" do
      expect(service).to receive(:execute).with(count: 6).and_return(users)

      cli.run(["--count", "6"])
    end

    it "calls the table formatter when no format is specified by the user" do
      allow(service).to receive(:execute).with(count: 5).and_return(users)
      expect(RandomPeople::Formatters::TableFormatter).to receive(:new).and_return(table_formatter)
      expect(table_formatter).to receive(:format).with(users)
      expect(json_formatter).not_to receive(:format)

      cli.run([])
    end

    it "calls the json formatter when json format is specified by the user" do
      allow(service).to receive(:execute).with(count: 5).and_return(users)
      expect(RandomPeople::Formatters::JsonFormatter).to receive(:new).and_return(json_formatter)
      expect(json_formatter).to receive(:format).with(users)
      expect(table_formatter).not_to receive(:format)

      cli.run(["--format", "json"])
    end

    it "raises custom error when unsupported format type is passed" do
      allow(service).to receive(:execute).and_return(users)
      expect {
        cli.run(["--format", "csv"])
    }.to raise_error(RandomPeople::UnsupportedFormatError, /Format csv is not supported/)
    end

    it "raises InvalidArgument error when count is passed as negative number" do 
      expect(service).not_to receive(:execute)
      
      expect {
        cli.run(["--count", "-5"])
      }.to raise_error(OptionParser::InvalidArgument, /Count must be a positive number/)
    end

    it "raises InvalidArgument error when a string is passed after --count" do
      expect(service).not_to receive(:execute)
      
      expect {
        cli.run(["--count", "format"])
      }.to raise_error(OptionParser::InvalidArgument)
    end

    it "raises InvalidArgument error when any invalid argument is passed" do
      expect(service).not_to receive(:execute)
      
      expect {
        cli.run(["--count", "4", "format", "json"])#user typed format instead of --format
      }.to raise_error(OptionParser::InvalidArgument, /Unrecognized arguments: format, json. Did you forget --?/)
    end

    it "displays 'no users found' when users array is empty" do
      allow(service).to receive(:execute).with(count: 5).and_return([])
      expect { 
        cli.run(["--count", "5"]) 
      }.to output(/No users found/).to_stdout
      
      cli.run(["--count", "5"])

    end
end