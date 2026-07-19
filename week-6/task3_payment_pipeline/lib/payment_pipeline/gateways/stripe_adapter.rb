module PaymentPipeline
  class StripeAdapter
    def initialize(stripe_gateway:)
      @stripe_gateway = stripe_gateway
    end

    def charge(amount:, currency:, card_token:)
      cents = (amount * 100).to_i
      response = @stripe_gateway.process_charge(cents: cents, currency_code: currency, token: card_token)

      PaymentResult.new(
        success: response[:ok],
        transaction_id: response[:confirmation],
        message: response[:reason] || "Stripe payment completed successfully"
      )
    
    rescue => e 
      PaymentResult.new(
        success: false,
        transaction_id: nil,
        message: "Gateway error: #{e.message}"
      )
    end
  end
end