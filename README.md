This repo is for learning purposes and it contains a few basic ruby scripts.

1. arrays.rb - declares two arrays, one array containing integers, one containing strings. 

on the num_array we use the sum method and print the result to the screen.

we also use the push method to add number 3 to the end of the array. This operation mutates the original array in memory. We use the p method to print the array as an actual object.

on the string array we use the pop method which removes the last element of the array. This operation also mutates the original array. 

2. conditionals.rb - in this script we ask the user to input their age. We save the input to a variable users_age using the gets method. By default this method also records the new line character which we need to remove using chomp method and we also convert the input from string to integer. 

We then use a simple if else block to determine if the user is allowed to drink or not based on their inputted age. 

3. each.rb - In this script we declare two array: names and numbers. On the first array we use the each method which iterates through the array and turns each element's character into an uppercase character. 

We also use the each method on the numbers array and we calculate the square of each number. 

4. hashes.rb - In this script we declare two hashes - employee and employees.

Employee is a simple hash which uses symbols as keys. It is using the new Ruby syntax using the colon after the symbol. 

Employees is a nested hash that uses integers as keys and contains other hashes as values inside a hash. 

5. hello.rb - This script compares different ways how to output a given string. For printing an output to the screen in Ruby we use mainly three methods: p, puts and print. 

6. loops.rb - In this script we explore looping using the times method and the object which specifies how many times we want the loop to run. We use two approaches for the loop. If the logic of the loop is simple we can write it on one line, but if we have a more complex logic which requires multiple lines of code, such as an if/else block, we use the do keyword. This essentially opens up a block of code to be repeated in each iteration. 

7. methods.rb - In this script we define two simple methods using the def keyword. Both methods accept arguments(s). Unlike in other languages though, in Ruby if the method does not accept any arguments we do not need to add the two parentheses at the end. Both of our methods return a value and when we call the methods we use the puts method to print this value to the screen. 

8. mini_challenge_vowels.rb - In this script we want to count the number of vowels in a given word entered by the user. We first get the user's input using the gets method and then remove the new line character at the end. To get the number of vowels we simply use the count method on the word object and pass the string containing all possible vowels as an argument. 

9. nested-loops.rb - in this script we explore how nested loops work. We declare two arrays called shirts and ties. We want to get all possible ways of how to combine each shirt with an appropriate tie. For this we can use a nested loop using the each method. 

In the outer loop we declare the local variable shirt and in the inner loop we declare the local variable tie. The bottom line here is that in the inner loop we also have access to the shirt variable from the outer loop so we can print a given combination in each iteration of the inner loop. 

10. variables.rb - In this script we just declare two variables and print each variable to the screen using a string interpolation. This works basically like an f string in Python or a template literal in Javascript. 

