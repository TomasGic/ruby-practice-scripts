RSpec.describe PaymentPipeline::NotificationService do
  let(:notification_service) { described_class.new }
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
    before do
      notification_service.update(failure_event, failure_data)
    end
    it "adds the failure event into the events hash" do
      expect(notification_service.events).to eq([event: failure_event, data: failure_data])
    end

    it "does not add a success event into the events array" do
      notification_service.update(success_event, success_data)
      expect(notification_service.events.size).to eq(1)
      expect(notification_service.events).not_to include(event: success_event, data: success_data)
    end
  end
end