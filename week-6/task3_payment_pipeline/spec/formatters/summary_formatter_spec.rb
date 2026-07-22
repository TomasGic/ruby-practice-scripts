RSpec.describe PaymentPipeline::SummaryFormatter do
  let(:formatter) { described_class.new }
  let(:request) do
    instance_double(
      PaymentPipeline::PaymentRequest,
      id: "REQ-12345",
      amount: 99.50,
      currency: "EUR",
      merchant: "Book Store",
      masked_card: "****4444"
    )
  end
  
  let(:result) do
    instance_double(
      PaymentPipeline::PaymentResult,
      success: true,
      transaction_id: 'TX-98765',
      message: 'Stripe payment completed successfully',
      gateway: 'stripe'
    )
  
  end

  describe "#format" do
    it "correctly outputs a string with payment ID, amount and status" do
      output = formatter.format(request, result)
      expect(output).to match(/Payment #[a-zA-Z0-9]{6}: 99\.50 EUR - SUCCESS/)
    end
  end
end