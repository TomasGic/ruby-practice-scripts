# Design patterns used across all 3 exercises

## Factory method pattern
* **Where it's used**: inside `BaseCalculator` class we define a class method `self.for` which accepts carrier as a parameter. This class method encapsulates the creation of a concreate shipping calculator (standard, express or overnight), which means the creation is hidden away from the main code. If we want to create a shippint calculator for standard carrier, we can use `calculator = Shipping::ShippingCalculator.for(carrier: :standard)`. This way, the creation of a concrete shipping calculator object is hidden away from the main code (our executable demo file).

* **problem it solved**: Factory method pattern decouples the selection and instantiation of a concrete shipping calculator class from the caller, which in our case is the demo script. If also simplifies the addition of a shipping calculator class for a new carrier. 

* **What the code would look like without the pattern**:
```
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
