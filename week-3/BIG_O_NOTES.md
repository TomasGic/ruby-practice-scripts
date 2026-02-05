# Task1 - Expense analyzer

Function/code block: CSV.foreach 
This is a loop which iterates through all rows of the csv file.
We denote the input into the function as n, which is the number of rows in the csv file.
Within the loop we also check if the row array contains any nil values using the include method. Here we denote the input as k, which is the number of columns in the csv file. 
Big-O is O(n k).

Function/code block: totals_by_category.each
This is a loop which iterates through the key-value pairs in the hash. 
n is the number of categories(keys)
Big-O is O(n)

Function/code block: all_rows.sort_by
This is a sorting function that sorts the array of hashes based on the expense amount. 
n is the number of parsed rows
Big-O is O(n log n)

Function/code block: sorted_rows_top3.each
This is a loop iterating through the rows of the sorted rows array.
n is the number of rows which in this case is 3
Big-O is O(n)

