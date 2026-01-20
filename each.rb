names = ['Tomas', 'Martin', 'Lukas']
names.each { |name| puts name.upcase }

numbers = [5, 2, 7, 8, 3, 4]
numbers.each do |number|
  square = number ** 2
  puts "#{number} squared equals #{square}."
end