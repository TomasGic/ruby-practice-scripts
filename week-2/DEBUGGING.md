During the development of this app I encountered one bug which taught me one important concept in Ruby, which is how it deals with truthy and falsy values. Unlike in Python, where empty strings and arrays are falsy objects which evaluate to false if used in an if statement, in Ruby only false and nil object are falsy. So an empty array will evaluate to true in Ruby. 

If we want to check if an array is empty in Python we can use 'if not array'.
If we want to do the same in Ruby, we have to use 'if array.empty?'. This is basically the equivalent of writing if array.length == 0, but using the empty method makes the code more readable. 

