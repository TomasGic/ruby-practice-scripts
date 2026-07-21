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

      expect(output).to include('REQ-12345')
      expect(output).to include('TX-98765')
      expect(output).to include('99.50 EUR')
      expect(output).to include('****4444')
      expect(output).to include('Stripe payment completed successfully')
    end
  end
end