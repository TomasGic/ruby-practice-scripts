module PaymentPipeline 
  class PaymentGateway
    def self.providers
      @providers ||= {}
    end
    
    def self.add_payment_provider(name:, adapter_class: self)
      name = name.to_sym
      providers[name] = adapter_class
    end

    def self.for(provider:)
      provider = provider.to_sym
      adapter_class = @providers[provider]
      raise UnknownProviderError, "Provider #{provider} not recognised" unless adapter_class
      adapter_class.new
    end

  end
end