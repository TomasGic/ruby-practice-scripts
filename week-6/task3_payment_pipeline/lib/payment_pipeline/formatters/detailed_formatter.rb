module PaymentPipeline
  class DetailedFormatter
    def format(request, result)
      <<~OUTPUT
        PAYMENT RESULT DETAILS 
        ------------------------------------------
        Status:         #{result.success ? 'Success' : 'Failed'}
        Transaction ID: #{result.transaction_id || 'N/A'}
        Timestamp:      #{Time.now.strftime("%Y-%m-%d %H:%M:%S")}
        Message:        #{result.message}
        
        PAYMENT REQUEST DETAILS 
        --------------------------------------------
        Request ID:     #{request.id}
        Merchant:       #{request.merchant}
        Amount:         #{'%.2f' % request.amount} #{request.currency}
        Gateway:        #{result.gateway}
        Card:           #{request.masked_card}
      OUTPUT
    end
  end
end