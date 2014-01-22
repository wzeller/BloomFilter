#This method has two main parts.  First it breaks a roman numeral up into "digits".  Then
#it translates each digit to an integer and adds them to produce the conversion.

def roman_numeral_to_integer (roman_numeral)

#The following is a dictionary with the keys set to roman numerals and values set to 
#their corresponding integer conversions.

values = [1000, 500, 100, 50, 10, 5, 1]
roman_numerals = ["M", "D", "C", "L", "X", "V", "I"]
roman_numeral_dict = Hash[roman_numerals.zip(values)]

#This section splits a number into separate roman numerals.

roman_numeral_letters = roman_numeral.split('').to_a

#Next we make sure all letters are valid numerals (at least facially -- not 
#whether they are "well-formed").

roman_numeral_letters.each {|letter| 

	if roman_numerals.include?(letter) == false

		puts "Invalid numerals.  Please enter another number."

		return nil

	end

}

#Next we add commas between all separate numerals.  For example, CCC is three
#numerals (3 100s), whereas XCIX is two 
#numerals (1 90 and 1 9).  The key to parsing roman numerals is realizing that a
#numeral ends when the next one in the sequence is either the same as it or less
#than it.  Thus the next loop adds a comma after any entry that is followed by a
#roman numeral either equal to or less than it.  However, when a letter is followed
#by a letter GREATER than it, that means the two letters are part of a single numeral,
#and the first is subtracted from the second.  

#After the loop is finished, we have an array with separate letters and commas between
#any two letters that constitute separate digits.  (E.g., for IXIV we would have an 
#array [I,X,",", I, V]).

roman_numeral_letters.each_with_index {|letter, index|

	if letter != "," && roman_numeral_letters[index+1] != nil

		if roman_numeral_dict[letter] >= roman_numeral_dict[roman_numeral_letters[index+1]]

			roman_numeral_letters.insert(index+1, ",")

		end

	end

}

#The next step is to rejoin the letters but split them by commas.  So, using IXIV, we now 
#have two strings, IX and IV, saved in an array.  

roman_numeral_letters = roman_numeral_letters.join.split(",")

#We use "roman_numeral_conversion" to add the digits values (calculated below)
#and convert to integer.

roman_numeral_conversion = 0

#The next loop goes through each string (i.e., separate numeral) in the array and adds their value to 
#the running total.  If the numeral is two characters long, the length of the array formed
#by splitting each character is 2 and we subtract the first and add the second to the total.
#Otherwise the character is simply translated to its number equivalent.

roman_numeral_letters.each {|numeral|

numeral = numeral.split("").to_a

if numeral.length == 1

	roman_numeral_conversion += roman_numeral_dict[numeral[0]]

else

	roman_numeral_conversion += roman_numeral_dict[numeral[1]]
	roman_numeral_conversion -= roman_numeral_dict[numeral[0]]

end

}

#Return the total value of all separate roman numerals.

return roman_numeral_conversion

end

