RSpec.describe PaymentPipeline::PaypalAdapter do
  let(:paypal_gateway_mock) { instance_double("PaypalGateway") }
  let(:adapter) { described_class.new(paypal_gateway: paypal_gateway_mock) }

  describe "#charge" do
    context "when paypal gateway process the payment successfully" do
      it "returns the PaymentResult object with correctly mapped data" do
        expect(paypal_gateway_mock).to receive(:send_payment)
        .with(amount_str: "50", currency: "EUR", reference: "tok-123")
        .and_return({ confirmation: "PP-123", status: "succeeded", error: nil })

        result = adapter.charge(amount: 50, currency: "EUR", card_token: "tok-123")

        expect(result.success).to be true
        expect(result.transaction_id).to eq("PP-123")
        expect(result.message).to eq("Paypal payment completed successfully")
      end
    end

    context "when the paypal gateway encounters an error" do
      it "returns the PaymentResult object with an error message" do
        allow(paypal_gateway_mock).to receive(:send_payment)
        .and_raise(StandardError.new("Connection timeout"))

        result = adapter.charge(amount: 50, currency: "EUR", card_token: "tok-123")
        expect(result.success).to be false
        expect(result.transaction_id).to be_nil
        expect(result.message).to eq("Gateway error: Connection timeout")
      end
      
    end
  end
end