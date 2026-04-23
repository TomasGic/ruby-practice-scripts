# Order management system
This is a small object-oriented Ruby project with event-driven behaviour. It simulates a real ordering system, such as is often used by e-commerce websites, and uses primarily two common design patterns - observer and decorator pattern.

# Decorator Pattern
We use the decorator pattern to add special attributes to our product objects (like gift wrapping or insurance) without modifying the base Product class or using complex inheritance. The decorator pattern allows us to stack multiple decorators, each adding a specific feature to our base product. 

## decorator interface
Every decorator wraps a product object and implements the same interface as the base product:

- name: Appends the decoration description (e.g., "Ergonomic Keyboard + Express Shipping + Insurance").

- price: Calculates the base price plus the additional cost of the decoration.

# Observer pattern
The Observer Pattern allows the Order class to notify other parts of the system (observers) when its state changes (e.g., when a new item is added and when an order is completed) without being tightly coupled to the observers.

The observer pattern is implemented using Observable module which is simply included in the Order class rather than hardcoded directly inside the Order class. This makes our system more flexible in case we want to add a new component that will need to notify observers as well.

# Running tests
This project was developed with Test-Driven Development (TDD) approach using a popular Ruby testing framework RSpec. To run the tests simply run the following command in the root project directory:

bundler exec rspec

