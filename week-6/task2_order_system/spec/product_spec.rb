RSpec.describe Orders::Product do
  it "initializes with name and price" do
    product = described_class.new(name: "Clean Code", price: 29.99)
    expect(product.name).to eq("Clean Code")
    expect(product.price).to eq(29.99)
  end

  it "raises InvalidPriceErrror when negative number is passed as price" do
    expect { 
      described_class.new(name: "Test product", price: -29.50) 
    }.to raise_error(Orders::InvalidPriceError, "Price cannot be negative.")
  end
end