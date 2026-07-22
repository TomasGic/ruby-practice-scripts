RSpec.describe PaymentPipeline::MetricsCollector do
  let(:metrics_collector) { described_class.new }
  let(:failure_event) { :validation_failed }
  let(:success_event) { :validation_passed }
  let(:failure_data) do
    {
      request_id: "123abc",
      error: "Fraudulent card detected",
      validator: "FraudValidator"
    }
  end
  let(:success_data) { {request_id: "123abc", status: "success"} }

  describe "#update" do
    it "correctly stores the number of successful and failed payments" do
      metrics_collector.update(failure_event, failure_data)
      metrics_collector.update(success_event, success_data)
      expect(metrics_collector.successful_payments).to eq(1)
      expect(metrics_collector.failed_payments).to eq(1)

    end
  end
end