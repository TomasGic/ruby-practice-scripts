# rspec spec/calculators_spec.rb
RSpec.describe Shipping::ShippingCalculator do
  describe ".for" do
    it "returns a StandardCalculator when carrier is :standard" do
      expect(Shipping::ShippingCalculator.for(carrier: :standard)).to be_a(Shipping::StandardCalculator)
    end

    it "returns an ExpressCalculator when carrier is :express" do
      expect(Shipping::ShippingCalculator.for(carrier: :express)).to be_a(Shipping::ExpressCalculator)
    end

    it "returns an OvernightCalculator when carrier is :overnight" do
      expect(Shipping::ShippingCalculator.for(carrier: :overnight)).to be_a(Shipping::OvernightCalculator)
    end


    it "raises UnknownCarrierError for invalid carriers" do
      expect { 
        Shipping::ShippingCalculator.for(carrier: :pigeon) 
      }.to raise_error(Shipping::UnknownCarrierError)
    end
  end
end
