RSpec.describe PaymentPipeline::DetailedFormatter do
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

  context "when payment is successful" do
    let(:result) do
      instance_double(
        PaymentPipeline::PaymentResult,
        success: true,
        transaction_id: 'TX-98765',
        message: 'Stripe payment completed successfully',
        gateway: 'stripe'
      )
    end

    it "formats the successful payment output correctly" do
      output = formatter.format(request, result)

      expect(output).to match(/Status:\s+Success/)
      expect(output).to match(/Request ID:\s+REQ-12345/)
      expect(output).to match(/Transaction ID:\s+TX-98765/)
      expect(output).to match(/Amount:\s+99.50 EUR/)
      expect(output).to match(/Card:\s+\*\*\*\*4444/)
      expect(output).to match(/Message:\s+Stripe payment completed successfully/)
    end


  end

  context "when payment fails" do
    let(:result) do
      instance_double(
        PaymentPipeline::PaymentResult,
        success: false,
        transaction_id: nil,
        message: "Gateway error: Connection timeout",
        gateway: "stripe"
      )
    end

    it "formats the failed payment output correctly" do
      output = formatter.format(request, result)

      expect(output).to match(/Status:\s+Failed/)
      expect(output).to match(/Request ID:\s+REQ-12345/)
      expect(output).to match(/Transaction ID:\s+N|A/)
      expect(output).to match(/Gateway error:\s+Connection timeout/)
    end
  end
end