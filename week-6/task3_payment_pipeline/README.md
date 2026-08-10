# Payment Processing System
This is a small object-oriented Ruby project that simulates processing payments through the full pipeline. The main goal of this project was to practice object-oriented programming and applying the appropriate design patterns. The design patterns used in this project are the following: 

## Chain of Responsibility
We use the chain of responsibility pattern to create a validation chain that validates an incoming payment request. Our program implements the `BaseValidator`super class which defines the common interface (`#validate`) and also holds the reference to the next validator(handler) in the chain (`@next_handler`). It also has a private method `#perform_validation` which is then overridden by the concrete validator classes (`FraudValidator`, `BalanceValidator`and `LimitValidator`). In this way, each validator class can implement its own validation logic which our client code does not know about. If the validation by a concrete validator passes and the validator holds reference to the next validator (handler), the request is passed on to the next handler. If the validation by a concrete validator fails, and there is a reference to the next handler, the validation chain stops executing and the `#validate` method returns a hash containing a failure message and the name of the validator class. 

## Adapter Pattern


## Strategy Pattern
The strategy pattern is used in the Processor class. Instead of letting the Processor class implement a specific formatting logic, we extract the logic into separate formatter classes (strategies) and inject the correct formatter object (strategy) via dependency injection into the processor. Our program implements three formatter classes (strategies) - `DetailedFormatter`, `SummaryFormatter` and `JsonFormatter`. All formatter classes implement a common interface (method)`#format` that accepts the raw payment result and payment request as arguments.

## Observer Pattern
Observer pattern is used in the `Processor` class which emits events at key moments during the execution of the `#process` method - when payment is started, when validation is passed or failed and when payment has succeeded or failed. The observer pattern has been implemented using a combination of Observable module and individual observer classes with `BaseObserver` as the super class and `AuditLogger`, `NotificationService` and `MetricsCollector` as subclasses. The Observable module supplies the Processor class with the method `#notify_observers` which accepts the event name as a symbol (first argument) and the event data as a hash(second argument). When `#notify_observers` is called inside `Processor#process`, it iterates over `@observers` array and calls `#update` on each observer. 

`#BaseObserver` defines the standard interface contract (`#update(event, data)`) and holds the event data inside the `@events` instance variable.

Concrete observers override the `#update` method if needed to store the incoming event data according to their own dedicated logic. 

