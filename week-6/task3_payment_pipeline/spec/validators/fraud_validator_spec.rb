RSpec.describe PaymentPipeline::FraudValidator do
    let(:blacklist) { ["4000000000000002"] }
    let(:fraudulent_request) do
        PaymentPipeline::PaymentRequest.new(
          id: 12345,
          amount: 40,
          currency: "EUR",
          card_number: 4000000000000002,
          merchant: "Book store"
        )
    end
    let(:good_request) do
      PaymentPipeline::PaymentRequest.new(
        id: 12345,
        amount: 40,
        currency: "EUR",
        card_number: 4000000000000001,
        merchant: "Book store"
      )
    end

    it "initializes with next handler as nil (instance variable inherited from base class)" do
        validator = described_class.new(blacklist: blacklist)
        expect(validator.next_handler).to be_nil
    end

    describe "#perform_validation" do
        it "returns failure when card number is in blacklist" do
            validator = described_class.new(blacklist: blacklist)
            result = validator.perform_validation(fraudulent_request)
            expect(result[:valid]).to be false
            expect(result[:error]).to eq("Validation failed: Fraudulent card detected")
            expect(result[:validator]).to eq("FraudValidator")
        end

        it "returns success when card number is not in blacklist" do    
            validator = described_class.new(blacklist: blacklist)
            result = validator.perform_validation(good_request)
            expect(result[:valid]).to be true
        end
      
    end
    

    
    
end