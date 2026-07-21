module PaymentPipeline
  class PaypalAdapter
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
    rescue => e
      PaymentResult.new(
        gateway: "paypal",
        success: false,
        transaction_id: nil,
        message: "Gateway error: #{e.message}"
      )
    end
  end
end