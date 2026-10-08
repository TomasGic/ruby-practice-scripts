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

  let(:cannot_validate_request) { double('Request', amount: nil)}
  let(:validator) { described_class.new(balance: balance) }

  describe "#validate" do
    context "when the payment request amount is nil" do
      it "returns the skipped validation error hash" do
        result = validator.validate(cannot_validate_request)
        expect(result[:valid]).to be false
        expect(result[:error]).to match(/Validation skipped/)
        expect(result[:validator]).to eq("BalanceValidator")
      end
    end
  end

  describe "#perform validation" do
    it "returns failure when payment amount exceeds balance" do
      result = validator.perform_validation(failing_request)
      expect(result[:valid]).to be false
      expect(result[:error]).to eq("Validation failed: Insufficient funds")
      expect(result[:validator]).to eq("BalanceValidator")
    end
  end
end