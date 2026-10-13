# Design patterns used across all 3 exercises

## Factory method pattern
* **Where it's used**: inside `BaseCalculator` class we define a class method `self.for` which accepts carrier as a parameter. This class method encapsulates the creation of a concreate shipping calculator (standard, express or overnight), which means the creation is hidden away from the main code. If we want to create a shipping calculator for standard carrier, we can use `calculator = Shipping::ShippingCalculator.for(carrier: :standard)`. This way, the creation of a concrete shipping calculator object is hidden away from the main code (our executable demo file).

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

## Template method pattern
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

```
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