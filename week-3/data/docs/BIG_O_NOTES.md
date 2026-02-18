# Task1 - Expense analyzer

## Function/code block: CSV.foreach 
This is a loop which iterates through all rows of the csv file.
We denote the input into the function as n, which is the number of rows in the csv file.
Within the loop we also check if the row array contains any nil values using the include method. Here we denote the input as k, which is the number of columns in the csv file. 
Big-O is O(n k).

## Function/code block: totals_by_category.each
This is a loop which iterates through the key-value pairs in the hash. 
n is the number of categories(keys)
Big-O is O(n)

## Function/code block: all_rows.sort_by
This is a sorting function that sorts the array of hashes based on the expense amount. 
n is the number of parsed rows
Big-O is O(n log n)

## Function/code block: sorted_rows_top3.each
This is a loop iterating through the rows of the sorted rows array.
n is the number of rows which in this case is 3
Big-O is O(n)


# Task2 - Markdown Knowledge Base Indexer

## Function: find_first_heading(filepath)
The function uses a loop File.foreach to iterate through each line of the file
n is the number of lines in the file
Within the file.foreach block we also use the scan method on each line to find the characters that match our regex pattern. The scan method is effectively a loop as well, so we can denote the input as k, which is the number of characters in the line.
Big-O of the whole function is O(n k)

## Function count_words(filepath)
The function uses a loop File.foreach which iterates through each line of the file.
n is the number of lines in the file.
For each line we use the split function to split the line into an array of words. This is effectively a loop which checks where the whitespace is in the line, so its time complexity depends on the number of characters in the line. We can denote the size of the input as k.
Big O is O(n k)

## Function count_tags(filepath)
Time complexity of this function is similar to count_words. It uses File.foreach to iterate through each line of the file. For each line it uses the scan method which iterates through each character of the line to check if it matches our regex pattern. 
Big-O is O(n k)

## Function find_most_common_words(filepath)
This function uses File.foreach to iterate through the lines in the file. 
The input of this loop is n, which is the number of lines.
For each line we iterate through the characters to extract only words. 
The input is k where k is the number of characters. 

For each word that we extract we check if the word is not a stopword and add it to the total word count. The input to this operation is m and is the number of words extracted. The operation of checking if the word is a stopword is constant because we used a set as a data structure for out stopwords variable, which uses hashing to find an element in the set.

At the end we sort the total_word_count hash which is big-O of O(j log j) - j is the number of unique words in the hash.

The overal big-O is O(n k + j log j )


