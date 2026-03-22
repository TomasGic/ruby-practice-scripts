require_relative "spec_helper"
require "json"
# rspec spec/user_mapper_spec.rb

RSpec.describe RandomPeople::UserMapper do
  let(:fixture_path) { File.expand_path("fixtures/random_people.json", __dir__) }
  let(:raw_data) { JSON.parse(File.read(fixture_path)) }
  let(:user_hash) { raw_data["results"].first }

  describe ".map_data" do 
    it "transforms user hash fetched from api into a user object" do
      user = described_class.map_data(user_hash)
      expect(user).to be_a(RandomPeople::User)
      expect(user.first_name).to eq(user_hash.dig("name", "first"))
      expect(user.last_name).to eq(user_hash.dig("name", "last"))
      expect(user.age).to eq(user_hash.dig("dob", "age"))
      expect(user.country).to eq(user_hash.dig("location", "country"))
    end
  end
end