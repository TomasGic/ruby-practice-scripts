module PaymentPipeline 
  class Processor 
    include Observable
    
    def initialize(validator_chain:, gateway:, formatter:, observers:)
      @validator_chain = validator_chain
      @gateway = gateway
      @formatter = formatter
      @observers = observers
    end

    def process(request)
      notify_observers(:payment_started, { request: request })
      validation_result = @validator_chain.validate(request)

      unless validation_result[:valid]
        notify_observers(:validation_failed, { request: request, result: validation_result })
        return <<~OUTPUT
          Request ID: #{request.id}
          Amount: #{'%.2f' % request.amount} #{request.currency}
          Card: #{request.masked_card}
          Message: #{validation_result[:error]}
          Validated by: #{validation_result[:validator]}
        OUTPUT
      end

      notify_observers(:validation_passed, { request: request, result: validation_result })

      payment_result = @gateway.charge(amount: request.amount, currency: request.currency, card_token: request.masked_card)

      if payment_result.success
        notify_observers(:payment_succeeded, { request: request, result: payment_result })
      else
        notify_observers(:payment_failed, { request: request, result: payment_result })
      end
      
      @formatter.format(request, payment_result)
    end
  end
end