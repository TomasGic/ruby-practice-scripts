RSpec.describe PaymentPipeline::AuditLogger do
  let(:audit_logger) { described_class.new }
  let(:event) { :validation_failed }
  let(:data) { {request_id: "123abc", error: "Fraudulent card detected", validator: "FraudValidator"} }
  describe "update" do
    it "adds an event along with event data into the events array" do
      audit_logger.update(event, data)
      expect(audit_logger.events).to eq([event: event, data: data])
      
    end
  end
end