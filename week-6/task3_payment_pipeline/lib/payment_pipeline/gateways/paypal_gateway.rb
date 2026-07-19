module PaymentPipeline
  class PaymentGateway
    def send_payment(amount_str:, currency:, reference:)
      { confirmation: "ST-#{rand(1000)}", status: "succeeded", error: nil }
    end
  end
end