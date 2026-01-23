num_array = [5, 8, 7, 6, 9]
s_array = ['Assassins Creed', 'GTA', 'Mafia', 'Manhunt', 'Rockstar Games']

puts "Sum: #{num_array.sum}"

#Methods that mutate the original array - push, pop

#We use the push method to add an element to the end of the array
num_array.push(3)
p num_array

puts "Sum: #{num_array.sum}"


#We use the pop method when we want to remove the last element 
s_array.pop()
p s_array


