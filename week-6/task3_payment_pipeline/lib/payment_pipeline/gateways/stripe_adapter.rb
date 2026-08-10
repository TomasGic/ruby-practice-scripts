module PaymentPipeline
  class StripeAdapter < PaymentGateway
    PaymentGateway.add_payment_provider(name: "stripe", adapter_class: self)
    
    def initialize(stripe_gateway: StripeGateway.new)
      @stripe_gateway = stripe_gateway
    end

    def charge(amount:, currency:, card_token:)
      cents = (amount * 100).to_i
      response = @stripe_gateway.process_charge(cents: cents, currency_code: currency, token: card_token)

      PaymentResult.new(
        gateway: "stripe",
        success: response[:ok],
        transaction_id: response[:confirmation],
        message: response[:reason] || "Stripe payment completed successfully"
      )
    
    rescue GatewayError => e 
      PaymentResult.new(
        gateway: "stripe",
        success: false,
        transaction_id: nil,
        message: "Gateway error: #{e.message}"
      )
    end
  end
end