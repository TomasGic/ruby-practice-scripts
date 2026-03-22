require_relative "spec_helper"
# rspec spec/user_spec.rb

#Testing the User class
RSpec.describe RandomPeople::User do
  let(:user1) do
    described_class.new(
      first_name: "Tomas",
      last_name: "Gic",
      age: 34,
      country: "Slovakia"
    )
  end
  
  let(:user2) do 
    described_class.new(
      first_name: "Thomas",
      last_name: "Gic",
      age: 17,
      country: "Slovakia"
    )
  end

  let(:user3) do
    described_class.new(
      first_name: "mary-ann",
      last_name: "gic ",
      age: "34",
      country: "slovakia"
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

  it "normalizes invalid arguments" do
    expect(user3.full_name).to eq("Mary-Ann Gic")
    expect(user3.country).to eq("Slovakia")
    expect(user3.age).to eq(34)
  end

  it "raises error if user object tries to initialize with empty string arugment" do
    expect {
      described_class.new(
        first_name: "",
        last_name: "gic ",
        age: "34",
        country: "slovakia"
      )
  }.to raise_error(RuntimeError, "first_name required")
  end    
end
