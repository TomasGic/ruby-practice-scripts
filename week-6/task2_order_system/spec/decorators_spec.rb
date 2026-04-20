RSpec.describe Orders::GiftWrapDecorator do

  let(:product) {Orders::Product.new(name: "Clean Code", price: 30.00)}
  it "adds 4.99 to the product's price but leaves the original price unchanged" do
    expect(described_class.new(product).price).to eq(34.99)
    expect(product.price).to eq(30.00)
  end

  it "adds Gift Wrap to the product name leaving original product name unchanged" do
    expect(described_class.new(product).name).to eq("Clean Code + Gift Wrap")
    expect(product.name).to eq("Clean Code")
  end
end

RSpec.describe Orders::InsuranceDecorator do

  let(:product) {Orders::Product.new(name: "Ergonomic keyboard", price: 100.00)}
  it "adds 9.99 to the product's price but leaves the original price unchanged" do
    expect(described_class.new(product).price).to eq(109.99)
    expect(product.price).to eq(100.00)
  end

  it "adds Insurance to the product name leaving original product name unchanged" do
    expect(described_class.new(product).name).to eq("Ergonomic keyboard + Insurance")
    
  end
end

RSpec.describe "Product Decorators Stacking" do
  let(:base_product) { Orders::Product.new(name: "Ergonomic keyboard", price: 100.00)}
  let(:wrapped_product) { Orders::GiftWrapDecorator.new(base_product) }
  let(:insured_wrapped) { Orders::InsuranceDecorator.new(wrapped_product) }
  let(:express_insured_wrapped) { Orders::ExpressShippingDecorator.new(insured_wrapped) }
  
  it "correctly stacks 2 decorators and accumulates price" do
    expect(insured_wrapped.price).to be_within(0.001).of(114.98)
    expect(insured_wrapped.name).to eq("Ergonomic keyboard + Gift Wrap + Insurance")
  end

  it "correctly stacks 3 decorators and accumulates price" do
    expect(express_insured_wrapped.price).to be_within(0.001).of(129.97)
  end

  it "raises an error when user tries to stack the same decorator twice" do
    expect {
      Orders::GiftWrapDecorator.new(insured_wrapped)
  }.to raise_error(Orders::DuplicateDecoratorError)
  end
end