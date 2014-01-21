=begin

The following are three algoritms that sort a list -- essentially replicating the functionality of the sort
method in Ruby.

The first is the most straightforward.  It's basically a bubble sort that cycles through an array 
swapping one entry with another if the latter is smaller.  It continues looping until there has been no
change (change = false) at which point the array is sorted and it can be returned.

The second creates two arrays, unsorted and sorted, and loops through the unsorted to find the minimum
value, which is added to sorted.  Then the min is deleted from unsorted and the process is repeated
until unsorted is empty.  This was straightforward except for repeated entries.  To deal with this I 
created a hash of the array with each key being the word and its value being the number of times the 
word appears.  That way, when a word is being added to the "sorted" array, I make hash[word] copies.

Last, and most complex, is a recursive sort algorithm that comprises two methods.  

The first is a recursive method to find the minimum entry in an array.  The edge case is when there are only
two entries left in the array, in which case it returns the smaller one.  Until then, the program compares
the first element in the array with the minimum of the remaining elements (defined in a separate
array equal to the array[1..-1]).  If the first element is less than the min of the rest, then
it is returned.  Otherwise the min of the rest is obtained by running the program on itself for 
array[1..-1], etc., until a min is reached, which is then returned.

The second method uses the min finder described above to sort an array.  It does so by setting up 
two arrays -- unsorted and sorted.  First the min of unsorted is found.  Then it's moved to 
sorted and deleted from unsorted.  The program continues running on itself (with the new 
unsorted and sorted arrays) until there is either 1 or 0 elements left
in unsorted, at which point it is moved to sorted and sorted is returned.  

The hard part was dealing with multiples.  To do so I hashed the unsorted array each time the method runs
and assign values for instances of each word.  Then, when the min is being moved to the sorted array,
I loop it the number of times corresponding to the hash value of the min (i.e., if there are 3
of them, that's the hash value and 3 copies of the word will be moved to sorted). 

=end

#Most straightforward -- implements bubble sort.

def sort(words)

list_of_words = words.each {|word| word.downcase}

change = true

#The while loop continues as long some switch occurs in the loop below, which changes "change" to 
#true.  If it loops with no switches, then change remains false and the loop ends as the list
#is sorted.

while change == true

	change = false

	list_of_words.each_with_index{

		|word, index| 

			if list_of_words[index+1] != nil && word > list_of_words[index+1]
#Swaps elements if the first is larger than the second.  
				list_of_words[index], list_of_words[index+1] = list_of_words[index+1], list_of_words[index]
				change = true
			end

	}

end

words.each{|word|

list_of_words.each_with_index{ |listWord, index|

if listWord.downcase == word.downcase
	list_of_words[index] = word
end

}

}
return list_of_words

end

puts sort(["Capital", "lower", "Bob", "Fred", "vern"])

#Slightly less straightforward.  Finds min of array, puts it into a "sorted" array, erases it from
#unsorted and repeats until everything is sorted.  Deals with doubles by creating a hash with each
#word as a key and the number of times the word appears as the value.  Then, when a word is moved
#to sorted, the number of copies made are its hash value (i.e., if there are 3 "the"'s, then 
#if "the" is the shortest word three copies are added to sorted_array).

def iterative_sort(array)

unsorted_array = array

#Create a hash listing the number of occurrences of each word in the array.

unsorted_array_hash = Hash.new(0)
unsorted_array.each {|word|
unsorted_array_hash[word] += 1}

sorted_array = []
shortest = 0

#Loop until unsorted is empty (as all words have been moved to sorted).

until unsorted_array.length == 0

#The loop adds the first element to "shortest" and compares the remaining elements
#to that variable.  If any is lower, then it is replaced as "shortest".  After looping 
#through the array, the min is identified and saved as shortest.

	unsorted_array.each {|word|

		if shortest == 0
			shortest = word
		elsif word < shortest
			shortest = word
		end

	}

#This loop adds the appropriate number of words to the sorted_array.  If there are multiple
#instances of a word, then, using the word's hash value, they are all copied into sorted_array.

	unsorted_array_hash[shortest].times {
		sorted_array << shortest
		double = 1
	}

#For the next iteration of the loop, the min word is deleted from unsorted_array, shortest
#is reset, and the process is repeated.

	unsorted_array.delete(shortest)
	shortest = 0

end

return sorted_array

end

#This recursive program continues until the array is only 2 elements when it
#returns the lesser one.  Until then, it takes the 
#first element and compares it with the array_minimum of the remaining numbers
#and, if lower, returns that number, otherwise returning array_min.  For 
#example, if the array is [5,4,3,2,1], the program will create an array called
#array2 = [4,3,2,1], which it will run the array_min on until it gets to [2,1], 
#when it will return 1, which 3 is not smaller than, which will return 1, and 4
#is not smaller than, which will again return 1 (as min of array2), and 5 is not 
#smaller than, resulting in a return of 1.

def array_minimum(array)

if array.length == 2 && array[0] < array[1]

	return array[0]

elsif array.length == 2 

	return array[1]

end

array2 = array[1..-1]

if array[0] < array_minimum(array2)
	
	return array[0]

else

	return array_minimum(array2)

end

end
		
#Finally a second method sorts the array.  To deal with the problem 
#of duplicates, we again create a hash with the numbers of each 
#element so they can be repeated when added to sorted_array.  
#The recursive loop continues until unsorted_array is 1 or 0, at 
#which point sorted_array is returned.  Each step runs the same
#process (identify min and switch to sorted, delete from unsorted)
#until the end case (unsorted only has 1 or 0 elements left) is reached.

def recursive_sort(unsorted_array, sorted_array)

#Store info. re repeats so they will all be moved to sorted array.

unsorted_array_hash = Hash.new(0)

	unsorted_array.each {|v|
		unsorted_array_hash[v] += 1}

#End cases.  We need to include 0 as well in case there are repeats
#at the end, in which case the unsorted array could go from 2 (or more)
#to 0.

if unsorted_array.length == 1

	return sorted_array << unsorted_array[0]

elsif unsorted_array.length == 0

	return sorted_array

end

#Identify the min number in unsorted.

lowest = array_minimum(unsorted_array)

#Identify how many times that number occurs.

lowest_numbers = unsorted_array_hash[lowest]

#Transfer all instances of lowest to sorted.

lowest_numbers.times {

sorted_array << lowest

}

#Delete the min from unsorted...

unsorted_array.delete(lowest)

#And repeat with the new unsorted/sorted arrays.

return recursive_sort(unsorted_array, sorted_array)

end


puts recursive_sort(["gg", "ff", "ff", "gg"], [])
