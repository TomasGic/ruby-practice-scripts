shirts = ['striped', 'plain white', 'plaid', 'checkered']
ties = ['polka dot', 'solid color', 'boring']

shirts.each do |shirt|
  ties.each do |tie|
    puts "#{shirt} with #{tie}"
  end
end