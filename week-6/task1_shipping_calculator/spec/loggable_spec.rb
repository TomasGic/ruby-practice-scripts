# rspec spec/loggable_spec.rb
RSpec.describe Shipping::Loggable do
  let(:test_class) { Class.new { include Shipping::Loggable } }
  subject { test_class.new }

  it "initializes with an empty logs array" do
    expect(subject.logs).to eq([])
  end

  it "records multiple calculation steps and appends them in the logs array" do
    subject.log("Calculation step 1")
    subject.log("Calculation step 2")

    expect(subject.logs.size).to eq(2)
    expect(subject.logs.first).to include("Calculation step 1")
    expect(subject.logs.last).to include("Calculation step 2")
  end
end