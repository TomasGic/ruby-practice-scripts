3.times { |n| puts "I am currently iterating on loop number #{n}."}

10.times do |n| 
  if n == 1
    puts "This is the #{n}st iteration of the loop."
  elsif n == 2
    puts "This is the #{n}nd iteration of the loop."
  elsif n == 3 
    puts "This is the #{n}rd iteration of the loop."
  else 
    puts "This is the #{n}th iteration of the loop."
  end
end
