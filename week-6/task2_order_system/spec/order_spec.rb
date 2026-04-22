RSpec.describe Orders::Order do
  let(:order) { described_class.new }
  let(:book) { instance_double("Product", name: "Clean Code", price: 30.00) }
  let(:keyboard) { instance_double("Product", name: "Ergonomic keyboard", price: 100.00)}
  let(:products) { [book, keyboard] }
  let(:book_wrapped) { Orders::GiftWrapDecorator.new(book) }
  let(:keyboard_express) { Orders::ExpressShippingDecorator.new(keyboard) }
  let(:decoroated_products) { [book_wrapped, keyboard_express] }
  it "initializes with empty items array and completed status set to false" do
    
    expect(order.items).to eq([])
    expect(order.completed).to eq(false)
  end

  describe "#add_item" do
    it "correctly adds two base products to the items array" do
      
      products.each do |p|
        order.add_item(product: p, quantity: 1)
      end

      expect(order.items.size).to eq(2)
      expect(order.items.first[:product_name]).to eq("Clean Code")
      expect(order.items.last[:product_name]).to eq("Ergonomic keyboard")
    end

    it "raises an error when quantity of 0 is passed" do
      expect {
        order.add_item(product: book, quantity: 0)
    }.to raise_error(Orders::InvalidQuantityError)
    end

    it "raises an error when negative quantity is passed" do
      expect {
        order.add_item(product: book, quantity: -2)
    }.to raise_error(Orders::InvalidQuantityError)
    end
  end
  
  describe "#total" do
    it "correctly calculates total after adding two base products" do
    
    products.each do |p|
      order.add_item(product: p, quantity: 1)
    end

    expect(order.total).to eq(130.00)
  end

    it "correctly calculates total after adding two decorated products" do
      decoroated_products.each do |p|
        order.add_item(product:p, quantity: 1)
      end

      expect(order.total).to be_within(0.001).of(149.98)
    end
  end

  describe "#item_count" do
    it "correctly calculates items count after adding two base products" do
      products.each do |p|
      order.add_item(product: p, quantity: 2)
      end

      expect(order.item_count).to eq(4)
    end
  end

  describe "#complete!" do
    it "marks order as completed(sets @completed to true)" do
      products.each { |p| order.add_item(product: p, quantity: 1) }
      order.complete!

      expect(order.completed).to eq(true)
    end

    it "raises an error when called on an empty order" do
      expect { order.complete! }.to raise_error(Orders::EmptyOrderError)
    end

    it "raises an error when called twice" do
      products.each { |p| order.add_item(product: p, quantity: 1) }
      order.complete!
      
      expect { order.complete! }.to raise_error(Orders::AlreadyCompletedError)
    end

    it "raises an error when trying to add items to an already completed order" do
      products.each { |p| order.add_item(product: p, quantity: 1) }
      order.complete!
      expect {
        order.add_item(product: book, quantity: 2)
    }.to raise_error(Orders::AlreadyCompletedError)
    end
  end
end   