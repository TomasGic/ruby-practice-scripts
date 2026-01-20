puts "What is your age? "
users_age = gets.chomp.to_i

if users_age > 18
  puts "You are allowed to drink alcohol!"
else 
  puts "You are NOT allowed to drink alcohol"
end
