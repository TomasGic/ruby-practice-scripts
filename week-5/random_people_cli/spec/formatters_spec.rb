# rspec spec/formatters_spec.rb
require "json"

RSpec.shared_context "formatter data" do
  let(:user1) do
    RandomPeople::User.new(
      first_name: "Tomas", 
      last_name: "Gic", 
      age: 34, 
      country: "Slovakia",
      email: "example@gmail.com"
    )
  end

  let(:user2) do
    RandomPeople::User.new(
      first_name: "Lukas", 
      last_name: "Rohac", 
      age: 17, 
      country: "Slovenia",
      email: "example2@gmail.com"
    )
  end

  let(:users) { [user1, user2] } 
end
RSpec.describe RandomPeople::Formatters::TableFormatter do
  
  include_context "formatter data"
  describe "#format" do
    it "returns a string containing the table headers" do
      table_formatter = described_class.new(users)
      output = table_formatter.format

      expect(output).to include("Full Name")
      expect(output).to include("Email")
      expect(output).to include("Age")
      expect(output).to include("Country")
      expect(output).to include("Group")
    end

    it "returns a string containing the table values" do
      table_formatter = described_class.new(users)
      output = table_formatter.format

      expect(output).to include("Tomas Gic")
      expect(output).to include("34")
      expect(output).to include("Slovakia")
      expect(output).to include("adult")
      expect(output).to include("example@gmail.com")
      expect(output).to include("Lukas Rohac")
      expect(output).to include("17")
      expect(output).to include("Slovenia")
      expect(output).to include("minor")
      expect(output).to include("example2@gmail.com")
    end

    it "returns 'no results found' when users array is empty" do
      users = []
      table_formatter = described_class.new(users)
      output = table_formatter.format

      expect(output).to eq("no results found")
    end
  end
end

RSpec.describe RandomPeople::Formatters::JsonFormatter do
  include_context "formatter data"
  describe "#format" do
    it "returns a valid JSON string" do
      json_formatter = described_class.new(users)
      users_json = json_formatter.format # this should return a json string
      users_hash = JSON.parse(users_json) # this should return a ruby hash

      expect(users_hash.first["full_name"]).to eq("Tomas Gic")
      expect(users_hash.first["group"]).to eq("adult")
      expect(users_hash.last["full_name"]).to eq("Lukas Rohac")
      expect(users_hash.last["group"]).to eq("minor")
    end
  end
  
end
