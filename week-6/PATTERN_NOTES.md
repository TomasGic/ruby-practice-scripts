# Design patterns used across all 3 exercises

## Factory Method Pattern
* **Where it's used**: inside `BaseCalculator` class we define a class method `self.for` which accepts carrier as a parameter. This class method encapsulates the creation of a concreate shipping calculator (standard, express or overnight), which means the creation is hidden away from the main code. If we want to create a shipping calculator for standard carrier, we can use `calculator = Shipping::ShippingCalculator.for(carrier: :standard)`. This way, the creation of a concrete shipping calculator object is hidden away from the main code (our executable demo file).

* **problem it solved**: Factory method pattern decouples the selection and instantiation of a concrete shipping calculator class from the caller, which in our case is the demo script. If also simplifies the addition of a shipping calculator class for a new carrier. 

* **What the code would look like without the pattern**:
```ruby
calculator = case carrier
             when :standard
               Shipping::StandardCalculator.new
             when :express
               Shipping::ExpressCalculator.new
             when :overnight
               Shipping::OvernightCalculator.new
             else
               raise "Unknown carrier: #{carrier}"
             end
```

* **Real-world example where the pattern is used**: The factory method pattern is used in web frameworks, such as Ruby on Rails, where the application writes generic database queries without knowing which database system is used (PostgreSQL, MySQL, SQLite, etc.).

You just configure `adapter: :postgresql` in the database config, and a factory method inspects this setting and returns the appropriate adapter instance (`PostgreSQLAdapter`, `Mysql2Adapter` or `SQLite3Adapter`).

## Template Method Pattern
* **Where it's used**: The template method pattern is implemented inside the `ShippingCalculator` base class that defines the main calculation algorithm (this is done inside the public method `#calculate`). The method outlines a template of steps that are needed to calculate the final shipping cost. The steps are as follows: 

1. Logging the package summary.
2. Computing the base rate.
3. Adding surcharges (if applicable).
4. Calculating discounts (if applicable).
5. Building the final result hash

The base class defines the template and lets the subclasses override the calculation steps if needed. 

### What problem it solved
* **Code duplication**: Since some steps of the calculation algorithm are identical for all subclasses, we can just define them in the base class and let the concrete subclasses decide if they want to accept the default implementation or override it. 

* **Inconsistent execution flows**: It guarantees that all calculators follow the exact same calculation and logging steps in the exact same order. A subclass cannot accidentally forget to log the summary or forget to compute a discount unless explicitly intended.

### What the code would look like without the pattern
Without using the template method pattern, our concrete calculator subclasses would have to override the entire `#calculate` from scratch. Since some steps of the calculation algorithm are shared between all subclasses, this would lead to code duplication and would validate the DRY (Do Not Repeat Yourself) principle.

```ruby
class StandardCalculator < ShippingCalculator
  include Loggable

  def calculate(package)
    log "Validating package: #{package.weight}kg, zone: #{package.zone}"
    base_rate = compute_base_rate(package)
    log "Base rate: #{currency}#{'%.2f' % base_rate}"
      
    surcharge = apply_surcharges(package)
    log(surcharge > 0 ? "Surcharge: #{currency}#{'%.2f' % surcharge}" : "No surcharges applied")
    
    subtotal = base_rate + surcharge
    discount = apply_discount(package, subtotal)
    log(discount > 0 ? "Discount: #{currency}#{'%.2f' % discount}" : "No discount applied")
    
    total = (subtotal - discount).round(2)
    log("Total: #{currency}#{'%.2f' % total}")
    build_result(base_rate: base_rate, surcharge: surcharge, discount: discount, total: total)

  end

  private 
  def compute_base_rate(package)
    package.weight * 0.50
  end

  def apply_surcharges(package)
    oversized?(package) ? 2.00 : 0.00
  end

  def apply_discount(package)
    package.weight > 10 ? (subtotal * 0.10) : 0.00
  end

  def build_result(base_rate:, surcharge:, discount:, total:)
      { 
        base_rate: base_rate,
        surcharge: surcharge,
        discount: discount,
        total: total
      }
    end

class ExpressCalculator < ShippingCalculator
  def calculate(package)
    # We would have to repeat the same calculation steps as in StandardCalculator just to change how `base_rate` or `surcharge` is computed!
    # repeat entire calculation algorithm here
  end
end
```

### Real-world example where the pattern is used
1. * **Active Record Callbacks and Lifecycle Hooks in Ruby on Rails**

* **Problem**: When saving or destroying a database record, Rails needs to run a predictable sequence of steps: validate data, trigger `before_save` callbacks, execute the SQL insert/update, trigger `after_save` callbacks, etc. 

* **How Template Method Pattern Solves It**: 
Rails defines the skeleton algorithm inside `ActiveRecord::Persistence#save`. It manages the transaction flow, error handling, and lifecycle state. However, it leaves "hooks" open for you (like `def before_save; ... end`) so you can inject custom behavior into specific steps of the framework's predefined algorithm without rewriting how a record gets saved.

2. **Framework-Driven Data Importers**

* **Problem**: Building a system that imports data from various third-party sources (e.g., importing users from a CSV file, a JSON API, and an FTP XML feed) without repeating the steps of the importing algorithm. While parsing each file format is unique, the overarching pipeline is identical:

1. Fetch/open the source file.
2. Parse the raw records into a hash
3. Save records into a database
4. Send a success or failure report

* **How Template Method Solves It: We create an `AbstractImporter` base class with an `#import` template method defining steps 1 through 5. Subclasses like `CsvImporter` or `ApiImporter` only override step 2 (`parse_records`), leaving the core database transaction and reporting orchestration cleanly centralized in the base class. 

## Decorator Pattern
### Where it's used
The decorator pattern is used in `decorators.rb` where we define a `ProductDecorator` class. This purpose of this class is to add special attributes to our product objects (like gift wrapping or insurance) without modifying the base `Product` class or using complex inheritance. The decorator pattern allows us to stack multiple decorators, each adding a specific feature to our base product. 

### What problem it solves
The decorator patterns solves the subclass explosion problem, where combining multiple product features would require its own subclass. For example, if we wanted to add both insurance and gift wrapping to our product without using the decorator pattern, we would have to create a subclass for each combination of features (`GiftWrapppedAndInsuredProduct` or `InsuredAndExpressShippedProduct`). With decorator pattern, we have only one subclass for each product feature and combining them is much easier, because we can wrap the product object inside one or more decorator objects that share the same interface, which allows us to add the features dynamically at runtime.

## What the code would look like without the pattern
Without the decorator pattern we would have to create a subclass for each combination of product features: 
```ruby
module Orders
  #product with gift wrapping and insurance
  class GiftWrappedAndInsuredProduct < Product
    def name
      "#{super} + Gift Wrap + Insurance"
    end

    def price
      super + 4.99 + 9.99
    end
  end

  #product with gift wrapping, insurance and express shipping
  class GiftWrappedInsuredAndExpresslyShippedProduct < Product
    def name 
      "#{super} + Gift Wrap + Insurance + Express Shipping"
    end

    def price 
      super + 4.99 + 9.99 + 14.99
    end
  end
```
Since there are 3 distinct product features, we would need 8 subclasses in total. Adding just 1 extra feature would cause the total number of subclasses to increase exponentially to 16!

## Real-world example where the pattern is used
* **Ruby Standard Library: HTTP & I/O Streams**: 
In lower-level networking and file processing, decorators wrap standard stream objects to layer on capabilities like buffering, compression, or encryption without modifying the base stream.

```ruby
require 'zlib'
require 'stringio'

# 1. Base Stream Object (raw byte payload)
raw_stream = StringIO.new(gzipped_binary_data)

# 2. Decorator: Wraps the raw stream with decompression behavior on the fly
decompressed_stream = Zlib::GzipReader.new(raw_stream)

# Reading from the decorator transparently reads and decompresses raw_stream bytes
content = decompressed_stream.read
```

## Observer Pattern
### Where it's used
The observer pattern is implemented using the `Observable` mixin and the `BaseObserver` class. The subject component of the observer pattern is actually the `Order` class, where `Observable` is included. Including the `Observable` mixin in the `Order` class ensures that `Order` has access to the mixin's methods. The reason the observer pattern is implemented using a mixin is the separation of concerns and reusability. The implementation of the methods that enable adding and notifying observers is encapsulated inside the `Observable` mixin keeping the `Order` class focused on order-related business logic, such as adding items and completing the order. If we ever need to build a class that will need to notify observers, we can simply reuse the `Observable` mixin.

The observer interface itself is implemented inside `BaseObserver` class: `def update(event, data)`, which is then inherited by the concrete observer classes, `EmailNotifier`, `AnalyticsTracker` and `InventoryManager`. 

### What problem it solves
The observer pattern solves the problem of tight coupling between the subject (in our case the `Order` class) holds state, and the objects that need to react when that state changes. The state that `Order` holds refers is captured by the two instance variables `@items` that stores the product hashes and `@completed` that stores a boolean value (`true` or `false`) and thus tracks the order completion. 

Without the observer pattern, the `Order` class would have to hold reference to the individual observers and it would need to know which methods to call on them. In other words, the `Order` class would be doing too much and such design would violate the Single Responsibility Principle. 

### What the code would look like without the pattern
```ruby
module Orders
  
  class Order
    attr_reader :items, :completed

    def initialize
      @items = []
      @completed = false

      @email_notifier = EmailNotifier.new
      @analytics_tracker = AnalyticsTracker.new
      @inventory_manager = InventoryManager.new
    end

    def add_item(product:, quantity:)
      unless quantity.is_a?(Integer) && quantity > 0
        raise InvalidQuantityError, "Quantity must be a positive integer."
      end 
      raise AlreadyCompletedError, "Cannot add items to already completed order" if @completed
      item = { product_name: product.name, count: quantity, total_price: product.price * quantity }
      @items << item
      
      @analytics_tracker.track_item_added(product: item[:product_name], quantity: item[:count])
      @inventory_manager.adjust_stock(product: item[:product_name], quantity: item[:count])
    end
  end
end
```

### Real-world examples where the pattern is used
The Observer pattern is used in applications where changes in one object need to be automatically reflected in multiple others:

* **Social Media Notifications**: Users (observers) receive updates when someone they follow (subject) posts new content.

* **Stock Market Apps**: Investors get real-time updates when stock prices (subjects) change.

* **Event Listeners in GUIs**: UI components respond to user actions like clicks or keyboard input.


## Adapter Pattern
### Where the pattern is used
The adapter pattern lives at the boundary layer where the program communicates with third-party payment gateway APIs. For each external payment service (our program uses Stripe and Paypal), we created its corresponding adapter class, `StripeAdapter` and `PaypalAdapter`. These adapter classes implement a common interface `#charge` that translates the response from each payment gateway into a payment result object that our program expects. 

### What problem it solves
The adapter pattern solves the problem of interface mismatch between the two payment gateways (stripe and paypal). Each interface accepts payment request data in slightly different formats and the they both return different response objects (hashes). The adapter pattern acts as a translator that converts our program's payment data format into the format that each payment gateway can process and also normalizes the responses into a uniform `PaymentResult` object.

### What the code would like without the pattern
Without the adapter pattern, the client code would be inflated with unneccessary conditional logic to determine which payment gateway (and which interface) needs to be used to process a given payment request. 

```ruby
module PaymentPipeline 
  class Processor 
    include Observable
    
    def initialize(validator_chain:, gateway_type:, gateway:, formatter:, observers:)
      @validator_chain = validator_chain
      @gateway = gateway 
      @formatter = formatter
      @observers = observers
    end

    def process(request)
      notify_observers(event: :payment_started, data: { request_id: request.id, amount: request.amount, merchant: request.merchant })
      validation_result = @validator_chain.validate(request)

      unless validation_result[:valid]
        return output_validation_failure(request, validation_result)
      end

      notify_observers(event: :validation_passed, data: { request_id: request.id })

      if @gateway.class.name == 'StripeGateway'
        cents = (request.amount.to_d * 100).to_i
        @gateway.process_charge(cents: cents, currency_code: request.currency, token: request.card_token)
      elsif @gateway.class.name == 'PaypalGateway'
        @gateway.send_payment(amount_str: request.amount.to_s, currency: request.currency, reference: request.card_token)
      end
    end
```

### Real-world examples where the pattern is used
* Software that use different file formats (like CSV, JSON, XML) uses adapters to convert these into a format that the application can work with. 

* Device drivers in operating systems impelement the standard interface that the OS Kernel expects to communicate with the hardware device, such as graphics card, keyboard, hard disks, etc. This is essentially the same adapter pattern used in our Ruby payment pipeline application. 

## Strategy Pattern
### Where it is used
In order to pinpoint where the strategy pattern is used, it is essential to first understand what the components of the strategy pattern are.

* **Context**:
The context is the intermediary between the client code (our demo script) and the strategy, delegating tasks to the selected strategy. It holds the reference to the strategy object and can switch between different strategies at runtime. In our application the context is the `Processor` class, and the strategy object is the formatter which is passed as an argument into the `Processor` class. 

* **Strategy interface**: 
Defines a common interface that all strategies must implement. In our application this is the `#format` method which varies for each concrete formatter.

* **Concrete strategies**: These are `SummaryFormatter`, `DetailedFormatter` and `JsonFormatter`.

* **Client**: This is the executable demo script. 

## What problem it solves
The strategy pattern solves several problems:

* **Bloated class and tight coupling**: Without the strategy pattern, the `Processor` class would contain the actual formatting logic inside `#process`. This would violate both the single responsibility principle and the open/close principle. Adding a new formatter would require changing the `Processor` class and the `#process` method would become bloated very quickly.

* **Testing the formatting logic would be difficult**: For example to test `SummaryFormatter`, we would have to run the entire `process` method. With the strategy pattern, we can test `SummaryFormatter` in isolation.

* **Limited code reusability**:
Without the strategy pattern, it is difficult to reuse the formatting algorithms (strategies) in other parts of the application. Strategy pattern solves this problem by encapsulating the formatting logic in separate classes which reduces code duplication and makes the application more easily maintanable. 

## What the code would look like without the pattern
```ruby
module PaymentPipeline 
  class Processor 
    include Observable
    
    def initialize(validator_chain:, gateway:, format_type:, observers:)
      @validator_chain = validator_chain
      @gateway = gateway
      @format_type = format_type
      @observers = observers
    end

    def process(request)
      notify_observers(event: :payment_started, data: { request_id: request.id, amount: request.amount, merchant: request.merchant })
      validation_result = @validator_chain.validate(request)

      unless validation_result[:valid]
        return output_validation_failure(request, validation_result)
      end

      notify_observers(event: :validation_passed, data: { request_id: request.id })

      payment_result = @gateway.charge(amount: request.amount, currency: request.currency, card_token: request.masked_card)

      if payment_result.success
        notify_observers(event: :payment_succeeded, data: { request_id: request.id, amount: request.amount, transaction_id: payment_result.transaction_id })
      else
        notify_observers(event: :payment_failed, data: { request_id: request.id, error: payment_result.message })
      end
      
      format_payment_result(request, payment_result)
    end

    private 

    def format_payment_result(request, result)
      case @format_type
      when :summary  
        "Payment #{request.id}: #{'%.2f' % request.amount} #{request.currency} - #{result.success ? 'SUCCESS' : 'FAILED'}"
      
      when :detailed
      <<~OUTPUT
        PAYMENT RESULT DETAILS 
        ------------------------------------------
        Status:         #{result.success ? 'Success' : 'Failed'}
        Transaction ID: #{result.transaction_id || 'N/A'}
        Timestamp:      #{Time.now.strftime("%Y-%m-%d %H:%M:%S")}
        Message:        #{result.message}
        
        PAYMENT REQUEST DETAILS 
        --------------------------------------------
        Request ID:     #{request.id}
        Merchant:       #{request.merchant}
        Amount:         #{'%.2f' % request.amount} #{request.currency}
        Gateway:        #{result.gateway}
        Card:           #{request.masked_card}
      OUTPUT

      when :json
        require 'json'
        JSON.pretty_generate(
          {
            result: {
              status: result.success ? "success" : "failed",
              transaction_id: result.transaction_id || "N/A",
              timestamp: Time.now.strftime("%Y-%m-%d %H:%M:%S"),
              message: result.message,
              gateway: result.gateway
            },
            request: {
              request_id: request.id,
              merchant: request.merchant,
              amount: "#{'%.2f' % request.amount} #{request.currency}",
              card: request.masked_card 
            }
          }
        )
      end
    end

    def output_validation_failure(request, validation_result)
      notify_observers(event: :validation_failed, data: { request_id: request.id, error: validation_result[:error], validator: validation_result[:validator] })
      @formatter.format(
        request,
        PaymentResult.new(
          gateway: "none",
          success: false,
          transaction_id: nil,
          message: validation_result[:error]
        )
      )
    end
  end
end
```

## Real-world examples where the pattern is used
* **E-commerce platforms** use the strategy pattern to implement different payment strategies (iDeal, Credit card, PayPal, etc.), similar to how they are implemented in our paypemt pipeline simulation app.

* **File Compression and Archiving Tools**: When a user backs up files or compresses a folder, they can choose different compression algorithms depending on whether they care about speed or maximum file reduction.

* **NPCs and Enemy Behaviours in Game Development**:
In video games, Non-Player Characters (NPCs) need to react dynamically to the player's actions or the difficulty setting. Game developers can switch an enemy's behavior on the fly (for example changing from defensive to aggressive when a boss enters "Phase 2") by simply swapping out the strategy object.