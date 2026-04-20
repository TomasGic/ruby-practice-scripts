RSpec.describe Orders::Product do
  it "initializes with name and price" do
    product = described_class.new(name: "Clean Code", price: 29.99)
    expect(product.name).to eq("Clean Code")
    expect(product.price).to eq(29.99)
  end
end