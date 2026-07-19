module PaymentPipeline
  class PaymentResult
    attr_reader :success, :transaction_id, :message
    
    def initialize(success:, transaction_id:, message:)
      @success = success
      @transaction_id = transaction_id
      @message = message
    end
  end
end