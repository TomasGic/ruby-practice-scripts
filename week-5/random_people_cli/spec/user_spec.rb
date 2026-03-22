require_relative "spec_helper"
# rspec spec/user_spec.rb

#Testing the User class
RSpec.describe RandomPeople::User do
  let(:user1) do
    described_class.new(
      first_name: "Tomas",
      last_name: "Gic",
      age: 34
    )
  end
  let(:user2) do 
    described_class.new(
      first_name: "Thomas",
      last_name: "Gic",
      age: 17
    )
  end
  it "initalizes with full name attribute" do 
    expect(user1.full_name).to eq("Tomas Gic")
  end

  it "outputs adult category for users aged 18 and above" do
    expect(user1.group).to eq("adult")
  end

  it "outputs minor category for users aged below 18" do
    expect(user2.group).to eq("minor")
  end
end

# Testing the UserMapper class
