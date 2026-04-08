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

RSpec.describe Shipping::StandardCalculator do
  let(:calculator) { Shipping::ShippingCalculator.for(carrier: :standard) }
  describe "#calculate" do
    it "correctly calculates result for a standard package (no discount, no surcharges)" do
      
      package = Shipping::Package.new(
        weight: 8.5,
        length: 60,
        width: 40,
        height: 30,
        zone: "urban"
      )

      result = calculator.calculate(package)

      expect(result[:base_rate]).to eq(4.25)
      expect(result[:surcharge]).to eq(0.00)
      expect(result[:discount]).to eq(0.00)
      expect(result[:total]).to eq(4.25)
    end

    it "correctly calculates result for an oversized package" do
      package = Shipping::Package.new(
        weight: 12.5, # we expect a 10% discount on the subtotal
        length: 120, # we expect surcharge 2.00 for length > 100cm
        width: 60,
        height: 30,
        zone: "urban"
      )

      result = calculator.calculate(package)
      
      expect(result[:base_rate]).to eq(6.25)
      expect(result[:surcharge]).to eq(2.00)
      expect(result[:discount]).to be_within(0.001).of(0.825)
      expect(result[:total]).to eq(7.43)
    end
  end
end

RSpec.describe Shipping::ExpressCalculator do 
  let(:calculator) { Shipping::ShippingCalculator.for(carrier: :express) }

  describe "#calculate" do
    it "correctly calculates result for package with a remote zone" do
      package = Shipping::Package.new(
        weight: 8.5,
        length: 60,
        width: 40,
        height: 30,
        zone: "remote_a" # we expect 3.00 surcharge for remote zone
      )

      result = calculator.calculate(package)

      expect(result[:base_rate]).to eq(10.2)
      expect(result[:surcharge]).to eq(3.00)
      expect(result[:discount]).to be_within(0.001).of(0.66)
      expect(result[:total]).to eq(12.54)
    end
  end
end

RSpec.describe Shipping::OvernightCalculator do
  let(:calculator) { Shipping::ShippingCalculator.for(carrier: :overnight) }

  describe "#calculate" do
    it "correctly calculates result for an oversized heavy package with a remote zone" do
      package = Shipping::Package.new(
        weight: 20.5, # we expect surcharge for weigth < 20 kg
        length: 120, # we expect 10.00 surcharge for length > 100
        width: 40,
        height: 30,
        zone: "remote_b" # we expect 5.00 surcharge for remote zone
      )
      
      result = calculator.calculate(package)

      expect(result[:base_rate]).to eq(61.5)
      expect(result[:surcharge]).to eq(23.0)
      expect(result[:discount]).to eq(0.00)
      expect(result[:total]).to eq(84.5)
    end
  end
end
