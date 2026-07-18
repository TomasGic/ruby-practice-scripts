RSpec.describe PaymentPipeline::LimitValidator do
  let(:failing_request) do
      PaymentPipeline::PaymentRequest.new(
        id: 12345,
        amount: 11000,
        currency: "EUR",
        card_number: 4000000000000002,
        merchant: "Mediamarkt"
      )
  end
  let(:validator) { described_class.new }

  describe "#perform_validation" do
    it "returns failure when transaction amount exceeds limit" do
      result = validator.perform_validation(failing_request)
      expect(result[:valid]).to be false
      expect(result[:error]).to eq("Validation failed: Limit exceeded")
      expect(result[:validator]).to eq("LimitValidator")
    end
  end
end