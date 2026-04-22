RSpec.describe Orders::Order do
  let(:order) { described_class.new }
  let(:book) { instance_double("Product", name: "Clean Code", price: 30.00) }
  let(:keyboard) { instance_double("Product", name: "Ergonomic keyboard", price: 100.00)}
  let(:products) { [book, keyboard] }
  let(:book_wrapped) { Orders::GiftWrapDecorator.new(book) }
  let(:keyboard_express) { Orders::ExpressShippingDecorator.new(keyboard) }
  let(:decoroated_products) { [book_wrapped, keyboard_express] }
  let(:email_notifier) { Orders::EmailNotifier.new }
  let(:analytics_tracker) { Orders::AnalyticsTracker.new }
  let(:observers) { [email_notifier, analytics_tracker] }
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

    it "notifies email observer with :item_added and :order_completed event and correct data" do
      order.add_observer(email_notifier)

      expect(email_notifier).to receive(:update).with(
        :item_added,
        {product: book.name, quantity: 1}
      )

      order.add_item(product: book, quantity: 1)

      expect(email_notifier).to receive(:update).with(
        :order_completed,
        {total: 30.00, count: 1}
      )

      order.complete!
    end

    it "does not notify observer when no observer has been added" do
      expect(email_notifier).not_to receive(:update)
      #we are adding item to the order without having added any observers
      order.add_item(product: book, quantity: 1)
    end

    it "notifies multiple observers with the same event" do
      observers.each { |obs| order.add_observer(obs) }
      observers.each do |obs| 
        expect(obs).to receive(:update).with(
        :item_added,
        {product: book.name, quantity: 1}
      )
      end

      order.add_item(product: book, quantity: 1)
    end

    it "notifies subsequent observers even if previous observer failed" do
      #we first add an email observer that will crash
      order.add_observer(email_notifier)
      
      #then we add an observer that will work correctly
      order.add_observer(analytics_tracker)

      #we let our bad email observer crash with a specific error message
      allow(email_notifier).to receive(:update).and_raise("Something went wrong")
      
      # we expect that adding an item to the order will print error message
      # but will not crash our program
      expect {
        order.add_item(product: book, quantity: 1)
    }.to output(/Failed to update observer/).to_stderr

    # we expect that our good observer will have updated correctly
    expect(analytics_tracker.events.size).to eq(1)
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

  describe "#add_observer" do
    it "adds observer objects to the @observers array" do
      observer1 = Object.new
      observer2 = Object.new
      order.add_observer(observer1)
      order.add_observer(observer2)

      expect(order.observers).to include(observer1, observer2)
    end
  end
end   