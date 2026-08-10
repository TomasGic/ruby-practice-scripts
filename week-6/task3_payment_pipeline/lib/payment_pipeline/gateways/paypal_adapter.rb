module PaymentPipeline
  class PaypalAdapter < PaymentGateway
    PaymentGateway.add_payment_provider(name: "paypal", adapter_class: self)
    
    def initialize(paypal_gateway:)
      @paypal_gateway = paypal_gateway
    end

    def charge(amount:, currency:, card_token:)
      response = @paypal_gateway.send_payment(amount_str: amount.to_s, currency: currency, reference: card_token)

      PaymentResult.new(
        gateway: "paypal",
        success: response[:status] == "succeeded" ? true : false,
        transaction_id: response[:confirmation],
        message: response[:error] || "Paypal payment completed successfully"
        
      )
    rescue GatewayError => e
      PaymentResult.new(
        gateway: "paypal",
        success: false,
        transaction_id: nil,
        message: "Gateway error: #{e.message}"
      )
    end
  end
end