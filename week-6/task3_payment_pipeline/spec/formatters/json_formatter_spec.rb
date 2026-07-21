require 'json'

RSpec.describe PaymentPipeline::JsonFormatter do
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
        transaction_id: "TX-98765",
        message: "Stripe payment completed successfully",
        gateway: "stripe"
      )
    end

    it "generates valid json with correct payment data" do
      output = formatter.format(request, result)
      parsed_output = JSON.parse(output)

      expect(parsed_output.dig("result", "status")).to eq("success")
      expect(parsed_output.dig("result", "transaction_id")).to eq("TX-98765")
      expect(parsed_output.dig("result", "message")).to eq("Stripe payment completed successfully")
      expect(parsed_output.dig("result", "gateway")).to eq("stripe")

      expect(parsed_output.dig("request", "request_id")).to eq("REQ-12345")
      expect(parsed_output.dig("request", "merchant")).to eq("Book Store")
      expect(parsed_output.dig("request", "amount")).to eq("99.50 EUR")
      expect(parsed_output.dig("request", "card")).to eq("****4444")
    end
  end
end