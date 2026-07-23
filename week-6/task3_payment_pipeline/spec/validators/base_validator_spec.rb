RSpec.describe PaymentPipeline::BaseValidator do
  let(:passing_test_request) { {should_run: true, should_pass: true } }
  let(:failing_test_request) { {should_run: true, should_pass: false } }
  let(:dummy_validator_class) do
    Class.new(described_class) do
      def can_validate?(request)
        request[:should_run]
      end


      def perform_validation(request)
        if request[:should_pass]
          return { valid: true }  
        else
          return { valid: false, error: "Validation failed", validator: self.class }
        end
      end
    end
  end
  it "initializes with next handler as nil if no next handler passed as argument" do
    validator = described_class.new
    expect(validator.next_handler).to be_nil
  end


  describe "validate" do
    context "when there is no next handler" do
      before do
        @validator = dummy_validator_class.new
      end
      it "returns a success hash when validation passes" do
        result = @validator.validate(passing_test_request)
        expect(result[:valid]).to be true
      end


      it "returns a failure hash when validation fails" do
        result = @validator.validate(failing_test_request)
        expect(result[:valid]).to be false
        expect(result[:error]).to eq("Validation failed")
        expect(result[:validator]).to eq(dummy_validator_class)
      end


      it "skips validation and returns success if validator cannot validate request" do
        request = { should_run: false }
        result = @validator.validate(request)
        expect(result[:valid]).to be true
      end
    end


    context "when there is next handler in the validation chain" do
      let(:next_validator) { dummy_validator_class.new }
      let(:chain) { dummy_validator_class.new(next_handler: next_validator) }
      it "passes the request on to the next handler if the first handler validates the request" do
        expect(next_validator).to receive(:validate).with(passing_test_request).and_call_original
        result = chain.validate(passing_test_request)
        expect(result[:valid]).to be true
      end


      it "stops the chain immediately and returns failure if the first validation fails" do
       
        expect(next_validator).not_to receive(:validate)
        result = chain.validate(failing_test_request)
        expect(result[:valid]).to be false
      end

      it "returns failure when first validation passes but the second one fails" do
        allow(next_validator).to receive(:validate).and_return(
          valid: false,
          error: "Second validation failed",
          validator: dummy_validator_class
        )

        result = chain.validate(passing_test_request)
        expect(result[:valid]).to be false
        expect(result[:error]).to eq("Second validation failed")
      end
    end
  end
end

