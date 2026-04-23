# Shipping Calculator System
This is a small object-oriented Ruby project that implements a shipping calculator logic using primarily two design patterns: factory method pattern and template method pattern. 

## Design patterns used
1. Factory method pattern - uses factory method to manage the creation of individual calculator objects. The main reason for using the factory method is to ensure that the object creation logic is hidden away from the main code. In our system it is implemented without any if/else or case statements, but rather using a registry hash variable which stores all the available carriers. The factory method simply looks up the specific carrier type that is passed as an argument and returns the correct instance of the calculator subclass. 

2. The Template method pattern - uses the template method to define the skeleton of the calculation algorithm in the parent class and lets individual calculator subclasses overwrite the specific steps when needed. In our system, the calculate method has 5 main steps: 
 
 - validate_package
 - compute_base_rate
 - apply_surcharges
 - apply_discount 
 - build_result

 Out of these 5 steps, only validate_package and build_result are defined in the parent class since they do not vary, the other three are defined in each subclass because they are different for each carrier type. 

 ## Loggable module
 In our system we use the Loggable module to define a consistent log method for each calculator. We could have also defined log method inside our base calculator class, but moving the logging behaviour inside a separate module makes the project more professional and easier to scale in case we want to add more classes that would need to implement a logging functionality. 

 ## Running the demo
 To see the calculators in action you can run the program by running bin/demo from the root project directory in your terminal.

 ## Running tests
 In the root project directory simply run the following command: 
 bundler exec rspec

 This will execute all tests.




