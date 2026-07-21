module PaymentPipeline
  class JsonFormatter 
    def format(request, result)
      require 'json'
      JSON.pretty_generate(
        {
          result: {
            status: result.success ? "success" : "failed",
            transaction_id: result.transaction_id || "N/A",
            timestamp: Time.now.strftime("%Y-%m-%d %H:%M:%S"),
            message: result.message,
            gateway: result.gateway
          },
          request: {
            request_id: request.id,
            merchant: request.merchant,
            amount: "#{'%.2f' % request.amount} #{request.currency}",
            card: request.masked_card 
          }
        }
      )
    end
  end
end