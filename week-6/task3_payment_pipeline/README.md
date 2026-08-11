# Payment Processing System
This is a small object-oriented Ruby project that simulates processing payments through the full pipeline. The main goal of this project was to practice object-oriented programming and applying the appropriate design patterns. The design patterns used in this project are the following: 

## Chain of Responsibility
We use the chain of responsibility pattern to create a validation chain that validates an incoming payment request. Our program implements the `BaseValidator`super class which defines the common interface (`#validate`) and also holds the reference to the next validator(handler) in the chain (`@next_handler`). It also has a private method `#perform_validation` which is then overridden by the concrete validator classes (`FraudValidator`, `BalanceValidator`and `LimitValidator`). In this way, each validator class can implement its own validation logic which our client code does not know about. If the validation by a concrete validator passes and the validator holds reference to the next validator (handler), the request is passed on to the next handler. If the validation by a concrete validator fails, and there is a reference to the next handler, the validation chain stops executing and the `#validate` method returns a hash containing a failure message and the name of the validator class. 

## Adapter Pattern
Our program uses the adapter pattern to solve the problem of incompatible interfaces used by our two gateway classes - `StripeGateway` and `PaypalGateway`. The former internally uses `#process_charge(cents, currency_code, token)`, wheres the latter implements a different interface, namely `#send_payment(amount_str, currency, reference)`. The role of the adapter is to convert the two different interfaces into one single interface that can be called in our `Processor` class (`gateway.charge(amount:, currency, card_token:)`). Since we cannot (or shouldn't) modify the individual gateway classes, we create an adapter class for each gateway - `StripeAdapter` for `StripeGateway` and `PaypalAdapter` for `PaypalGateway`. Each adapter class instance is instantiated with the respective payment gateway object(stripe or paypal) via the initialize method.  

## Strategy Pattern
The strategy pattern is used in the Processor class. Instead of letting the Processor class implement a specific formatting logic, we extract the logic into separate formatter classes (strategies) and inject the correct formatter object (strategy) via dependency injection into the processor. Our program implements three formatter classes (strategies) - `DetailedFormatter`, `SummaryFormatter` and `JsonFormatter`. All formatter classes implement a common interface (method)`#format` that accepts the raw payment result and payment request as arguments.

## Observer Pattern
Observer pattern is used in the `Processor` class which emits events at key moments during the execution of the `#process` method - when payment is started, when validation is passed or failed and when payment has succeeded or failed. The observer pattern has been implemented using a combination of Observable module and individual observer classes with `BaseObserver` as the super class and `AuditLogger`, `NotificationService` and `MetricsCollector` as subclasses. The Observable module supplies the Processor class with the method `#notify_observers` which accepts the event name as a symbol (first argument) and the event data as a hash(second argument). When `#notify_observers` is called inside `Processor#process`, it iterates over `@observers` array and calls `#update` on each observer. 

`#BaseObserver` defines the standard interface contract (`#update(event, data)`) and holds the event data inside the `@events` instance variable.

Concrete observers override the `#update` method if needed to store the incoming event data according to their own dedicated logic. 

## Factory Method Pattern
Our program uses the factory method pattern to encapsulate the logic of creating the payment gateway adapters. This is done inside the `PaymentGateway` class using the class method `.for`. If we didn't apply the factory method pattern, we would have to create the adapter instances inside our client code with the help of an if/else block, which would result in a bloated and messy codebase. 

The `PaymentGateway` class also implements `.add_payment_provider` which dynamically registers a payment provider in the providers hash (`@providers`). Instead of registering the provider at runtime in our client code, we encapsulate the registration inside each adapter class by adding `PaymentGateway.add_payment_provider(name: "stripe", adapter_class: self)` at the top of the `StripeAdapter` class and `PaymentGateway.add_payment_provider(name: "paypal", adapter_class: self)` at the top of the `PaypalAdapter` class. This works because Ruby executes the code inside the class block as soon as the file where the class lives is evaluated. In this way, we do not have to add the provider at runtime and if we introduce a new payment provider into our program, we simply create a new file with the new adapter class and require it - no changes to `PaymentGateway` class are needed.  

 When we call `PaymentGateway.for(provider: "stripe")` the factory method looks up the specific provider type in the providers hash and returns the correct instance of the adapter class. 

 ## Running the demo
 To see the payment pipeline in action you can run the program by running `bin/demo` from the root project directory in your terminal.

 ## Running tests
 In the root project directory simply run the following command: 
 `bundler exec rspec`

 This will execute all tests.