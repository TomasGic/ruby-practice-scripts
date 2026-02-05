# Main bugs encountered

1. Undefined method + for nilClass
I've encountered this bug when trying to increase the count of a hash key that did not exist previously in an empty hash defined as {}. The reason was Ruby was trying to execute nil + value which is an invalid operation. 

Fix: initialise an empty hash as Hash.new(0) or Hash.new(0.0)

2. A float with too many decimal points as a result of rounding.
I've encountered this bug when trying to round the error rate percentage in the log_analyzer script. The rounded value was 32.7000000004. 

Fix: Using formatting to display the float as a string for better readability. 

3. Performing calculations with the expenses amount parsed from the csv file
I've encountered this bug when trying to perform calculations with the value parsed from the csv file expenses.csv. I forgot that by default all the values from the csv file are parsed as strings. 

Fix: when parsing the values convert them to float using .to_f

