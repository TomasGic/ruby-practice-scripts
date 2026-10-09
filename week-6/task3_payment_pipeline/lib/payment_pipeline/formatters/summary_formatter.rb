module PaymentPipeline
  require 'securerandom'
  class SummaryFormatter 
    def format(request, result)
      "Payment #{request.id}: #{'%.2f' % request.amount} #{request.currency} - #{result.success ? 'SUCCESS' : 'FAILED'}"
    end
  end
end