RSpec.describe PaymentPipeline::Processor do
  
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

  let(:validator_chain) do
    PaymentPipeline::FraudValidator.new(blacklist: [],
      next_handler: PaymentPipeline::BalanceValidator.new(balance: 20000,
      next_handler: PaymentPipeline::LimitValidator.new
      )
    )
  end

  let(:gateway) { PaymentPipeline::StripeAdapter.new }
  let(:formatter) { PaymentPipeline::SummaryFormatter.new }
  let(:observers) { [PaymentPipeline::AuditLogger.new, PaymentPipeline::MetricsCollector.new] }
  let(:processor) do
    described_class.new(
      validator_chain: validator_chain,
      gateway: gateway,
      formatter: formatter,
      observers: observers
    )
  end
  describe "#process" do
    it "returns the correct validation result" do
      expect(validator_chain).to receive(:validate).with(request).and_return({valid: true})
      processor.process(request)
    end

    it "notifies observers with events :payment_started, :validation_passed and :payment_succeeded" do
      observers.each do |observer|
        expect(observer).to receive(:update).with(
          :payment_started, { request: request }
        ).ordered
      end

      observers.each do |observer|
        expect(observer).to receive(:update).with(
          :validation_passed, { request: request, result: { valid: true } }
        )
      end

      observers.each do |observer|
        expect(observer).to receive(:update).with(
          :payment_succeeded, { request: request, result: kind_of(PaymentPipeline::PaymentResult) }
        )
      end
      
      processor.process(request)
    end

    it "uses the formatter to format the successful payment result" do
      expect(formatter).to receive(:format).and_return("Payment REQ-12345: 99.50 - SUCCESS")
      result = processor.process(request)
      expect(result).to include("SUCCESS")
    end

    it "terminates the payment flow when validation fails" do
      allow(validator_chain).to receive(:validate).with(request).and_return(
        {
          valid: false,
          error: "Validation failed"
        }
      )
      expect(gateway).not_to receive(:charge)
      result = processor.process(request)
      expect(result).to include("Request ID: REQ-12345")
      expect(result).to include("Validation failed")
      
    end
  end
end