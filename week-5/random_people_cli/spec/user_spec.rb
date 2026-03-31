# rspec spec/user_spec.rb

#Testing the User class
RSpec.describe RandomPeople::User do
  let(:user_adult) do
    described_class.new(
      first_name: "Tomas",
      last_name: "Gic",
      age: 34,
      country: "Slovakia",
      email: "example@gmail.com"
    )
  end
  
  let(:user_minor) do 
    described_class.new(
      first_name: "Thomas",
      last_name: "Gic",
      age: 17,
      country: "Slovakia",
      email: "example@gmail.com"
    )
  end

  let(:user_invalid) do
    described_class.new(
      first_name: "mary-ann",
      last_name: "gic ",
      age: "34",
      country: "slovakia",
      email: "EXAMPLE@GMAIL.COM"
    )
  end

  let(:user_missing_arg) do
    described_class.new(
      first_name: "Tomas",
      last_name: nil,
      age: 34,
      country: "Slovakia",
      email: nil
    )
  end

  let(:user_negative_age) do
    described_class.new(
      first_name: "Tomas",
      last_name: nil,
      age: -34,
      country: "Slovakia",
      email: nil
    )
  end

  it "outputs full name from first name and last name" do
    expect(user_adult.full_name).to eq("Tomas Gic")
  end

  it "outputs adult category for users aged 18 and above" do
    expect(user_adult.group).to eq("adult")
  end

  it "outputs minor category for users aged below 18" do
    expect(user_minor.group).to eq("minor")
  end

  it "normalizes invalid arguments" do
    expect(user_invalid.first_name).to eq("Mary-Ann")
    expect(user_invalid.last_name).to eq("Gic")
    expect(user_invalid.country).to eq("Slovakia")
    expect(user_invalid.age).to eq(34)
    expect(user_invalid.email).to eq("example@gmail.com")
  end

  it "replaces arguments that are nil with N/A" do
    expect(user_missing_arg.last_name).to eq("N/A")
    expect(user_missing_arg.email).to eq("N/A")
  end

  it "replaces negative age with 'Invalid' and sets group as 'N/A" do
     expect(user_negative_age.age).to eq("Invalid")
     expect(user_negative_age.group).to eq("N/A")
  end
end
