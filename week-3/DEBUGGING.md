# Main bugs encountered

1. Undefined method + for nilClass
I've encountered this bug when trying to increase the count of a hash key that did not exist previously in an empty hash defined as {}. The reason was Ruby was trying to execute nil + value which is an invalid operation. 

Fix: initialise an empty hash as Hash.new(0) or Hash.new(0.0)

2. A float with too many decimal points as a result of rounding.
I've encountered this bug when trying to round the error rate percentage in the log_analyzer script. The rounded value was 32.7000000004. 

Fix: Using formatting to display the float as a string for better readability. 


