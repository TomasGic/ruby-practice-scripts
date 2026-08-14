module PaymentPipeline
  class PaypalGateway
    require 'securerandom'
    
    def send_payment(amount_str:, currency:, reference:)
      { confirmation: "PP-#{SecureRandom.hex(6)}", ok: true, reason: nil }
    end
  end
end