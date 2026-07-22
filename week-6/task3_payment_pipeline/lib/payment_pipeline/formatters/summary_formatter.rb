module PaymentPipeline
  require 'securerandom'
  class SummaryFormatter 
    def format(request, result)
      payment_id = generate_payment_id
      "Payment #{payment_id}: #{'%.2f' % request.amount} #{request.currency} - #{result.success ? 'SUCCESS' : 'FAILED'}"
    end

    def generate_payment_id
      "##{SecureRandom.alphanumeric(6).downcase}"
    end
  end
end