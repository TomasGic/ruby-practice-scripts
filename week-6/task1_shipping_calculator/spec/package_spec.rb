#rspec spec/package_spec.rb

RSpec.describe Shipping::Package do
  let(:package) do 
    Shipping::Package.new(
      weight: 8.5,
      length: 60,
      width: 40,
      height: 30,
      zone: "urban"
    )
  end

  it "properly stores all the attributes" do
    expect(package.weight).to eq(8.5)
    expect(package.length).to eq(60)
    expect(package.width).to eq(40)
    expect(package.height).to eq(30)
    expect(package.zone).to eq("urban")  
  end

  describe "validating package dimensions" do 
    it "throws InvalidPackageError if weight is 0" do
      expect {
        Shipping::Package.new(weight: 0, length: 40, width: 20, height: 10, zone: "urban")
      }.to raise_error(Shipping::InvalidPackageError, /cannot be negative or zero/)
    end

    it "throws InvalidPackageError if dimensions are negative or 0" do
      expect { 
        Shipping::Package.new(weight: 5, length: -40, width: 0, height: 0, zone: "urban")
      }.to raise_error(Shipping::InvalidPackageError, /cannot be negative or zero/)
    end

    it "throws InvalidPackageError if invalid zone is passed (moon)" do
      expect { 
        Shipping::Package.new(weight: 5, length: 40, width: 20, height: 10, zone: "moon")
      }.to raise_error(Shipping::InvalidPackageError, /Zone must be one of/)
    end

    it "converts dimensions to floats if passed as string" do
      package = Shipping::Package.new(weight: "5.4", length: "40.25", width: "20.4", height: "10", zone: "urban")
      expect(package.weight).to be_a(Float)
      expect(package.weight).to eq(5.4)
      expect(package.length).to be_a(Float)
      expect(package.length).to eq(40.25)
      expect(package.width).to be_a(Float)
      expect(package.width).to eq(20.4)
      expect(package.height).to be_a(Float)
      expect(package.height).to eq(10.0)
    end
  end
end