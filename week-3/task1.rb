require "csv"

total_amount = 0
number_of_rows = 0
totals_by_category = Hash.new(0.0)
all_rows = []

CSV.foreach("data/expenses.csv", headers: true) do |row|
  next if row.fields.compact.empty?
  number_of_rows += 1
  current_amount = row["amount"].to_f
  category = row["category"]
  total_amount += current_amount
  totals_by_category[category] += current_amount
  all_rows.push(row)
end

puts "Total number of rows parsed is #{number_of_rows}."
puts "Total amount of all expenses is $#{total_amount.round(2)}."
puts "-----------------------------"
puts "Expenses by category:"
totals_by_category.each do |category, amount| 
  puts "#{category} - $#{amount}"
end
puts "-----------------------------"
sorted_rows = all_rows.sort_by { |row| row["amount"].to_f }.reverse
sorted_rows_top3 = sorted_rows[0,3]
puts "Top 3 expenses:"
sorted_rows_top3.each do |row|
  puts "#{row["date"]}, #{row["category"]}, #{row["description"]}, #{row["amount"]}"
end





