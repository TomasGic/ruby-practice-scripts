RSpec.describe PaymentPipeline::BalanceValidator do
  let(:balance) { 2000 }
  let(:failing_request) do
      PaymentPipeline::PaymentRequest.new(
        id: 12345,
        amount: 3000,
        currency: "EUR",
        card_number: 4000000000000002,
        merchant: "Mediamarkt"
      )
  end
  let(:validator) { described_class.new(balance: balance) }

  describe "#perform validation" do
    it "returns failure when payment amount exceeds balance" do
      result = validator.perform_validation(failing_request)
      expect(result[:valid]).to be false
      expect(result[:error]).to eq("Validation failed: Insufficient funds")
    end
  end
end