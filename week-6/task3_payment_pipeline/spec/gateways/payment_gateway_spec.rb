RSpec.describe PaymentPipeline::PaymentGateway do
  
  describe ".add_payment_provider" do
    it "correctly registers a payment provider into the providers hash" do
      described_class.add_payment_provider(name: "stripe", adapter_class: PaymentPipeline::StripeAdapter)
      expect(described_class.providers).to include(stripe: PaymentPipeline::StripeAdapter)
    end
  end

  describe ".for" do
    before do
      described_class.instance_variable_set(:@providers, {})
    end
    it "returns the instance of StripeAdapter when stripe provider is passed" do
      described_class.add_payment_provider(name: "stripe", adapter_class: PaymentPipeline::StripeAdapter)
      expect(described_class.for(provider: "stripe")).to be_a(PaymentPipeline::StripeAdapter)
    end

    it "raises an error when we pass a payment provider that has not been registered yet" do
      expect{
        described_class.for(provider: "stripe")
    }.to raise_error(PaymentPipeline::UnknownProviderError, "Provider stripe not recognised")
    end
  end
end
