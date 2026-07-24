RSpec.describe PaymentPipeline::PaymentRequest do
  let(:request) {
    described_class.new(
      id: 12345,
      amount: 40,
      currency: "EUR",
      card_number: 1234567812345678,
      merchant: "Book Store"
    )
  }
  it "initializes with a masked card number (only last 4 digits visible)" do
    expect(request.masked_card).to eq("****5678")
  end

  it "raises InvalidCardError when card number is not exactly 16 digits long" do

    expect {
      described_class.new(
        id: 12345,
        amount: 40,
        currency: "EUR",
        card_number: 123456781234567,
        merchant: "Book Store"
      )
  }.to raise_error(PaymentPipeline::InvalidCardError, "Card number must be exactly 16 digits")
  end
end