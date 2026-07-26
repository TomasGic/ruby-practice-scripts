RSpec.describe PaymentPipeline::StripeAdapter do
  let(:stripe_gateway_mock) { instance_double("StripeGateway") }
  let(:adapter) { described_class.new(stripe_gateway: stripe_gateway_mock)}
  describe "#charge" do
    context "when stripe gateway processes the payment successfully" do
      it "returns the Payment Result object with correctly mapped data" do
        expect(stripe_gateway_mock).to receive(:process_charge)
        .with(cents: 5000, currency_code: "EUR", token: "tok-123")
        .and_return({ confirmation: "ST-123", ok: true, reason: nil })

        result = adapter.charge(amount: 50.00, currency: "EUR", card_token: "tok-123")

        expect(result.success).to be true
        expect(result.transaction_id).to eq("ST-123")
        expect(result.message).to eq("Stripe payment completed successfully")
      end
    end

    context "when the stripe gateway encounters an error" do
      it "returns the PaymentResult object with an error message" do
        allow(stripe_gateway_mock).to receive(:process_charge)
        .and_raise(PaymentPipeline::GatewayError.new("Connection timeout"))

        result = adapter.charge(amount: 50.00, currency: "USD", card_token: "tok_123")

        expect(result.success).to be false
        expect(result.transaction_id).to be_nil
        expect(result.message).to eq("Gateway error: Connection timeout")
      end
    end
  end
end