module PaymentPipeline
 
  class BaseValidator
    attr_reader :next_handler
   
    def initialize(next_handler: nil)
      @next_handler = next_handler
    end


    def validate(request)
      if can_validate?(request)
        result = perform_validation(request)
        #if validation fails, result[:valid] is false and we stop the validation chain
        return result unless result[:valid]
      end


      #if validation succeeds we pass the validation on to the next handler if there is one
      if @next_handler
        return @next_handler.validate(request)
      end
      
      #if earlier validation was successful or a given validator is unable to validate the request the method returns the hash below
      { valid: true }
    end


    def can_validate?(request)
      raise NotImplementedError, "#{self.class} must implement #can_validate?"
    end


    def perform_validation(request)
      raise NotImplementedError, "#{self.class} must implement #perform_validation"
    end
  end
end
