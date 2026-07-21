module PaymentPipeline
  class PaymentResult
    attr_reader :success, :transaction_id, :message, :gateway
    
    def initialize(success:, transaction_id:, message:, gateway:)
      @success = success
      @transaction_id = transaction_id
      @message = message
      @gateway = gateway
    end
  end
end