#I first wrote a single method that handled the entire process of encoding
#numbers to roman numerals, but it was very confusing and unweildy.  
#I realized that the formation of roman numerals can be done digit-by-digit
#as long as you know what place in the base ten number you're at and the 
#digit.  So, to make the code clearer, I redid it with two methods -- one
#that translates a single base-ten digit to roman numerals, and the second
#that breaks down an integer into digits and then sequentially converts each
#digit to roman numerals, adds each roman numeral to an array, and returns the
#joined numerals.


#This method returns a roman numeral for any digit, 0-9, as long as the value
#is 1000 or less (and, if it is 1000, the digit is 4 or less).

def digit_to_roman(digit, value)

#First I create a Hash with all values and corresponding roman numerals.

values = [1000, 500, 100, 50, 10, 5, 1]
roman_numerals = ["M", "D", "C", "L", "X", "V", "I"]
roman_numeral_dict = Hash[values.zip(roman_numerals)]

#Then there are a number of if tests that handle all cases.

#First ensure the value is 1000 or less

	if value > 1000 || values.include?(value) == false

		puts "Value over 1000 or invalid.  Please enter another."

		return nil

	end 

#The 1000 values do not include a normal "4" and can only go up to 4.

	if value == 1000 

		if digit < 5


#The next line would return, e.g., 4 M's if the digit was 4 and value was 1000.

			return roman_numeral_dict[value] * digit  

		else

			puts "Number higher than 4999.  Please input another number."

			return nil 

		end

	end

#Now we handle 100s, 10s, 1s, and improper inputs.

#First digits between 5 and 8, which include a "5" form (either D or L or V) 
#plus the remainder.

	if digit >= 5 && digit != 9  && digit < 10

#This simplifies the code because the "5" form is always 5 times the value.

		five_part = roman_numeral_dict[value*5]
		non_five_part = roman_numeral_dict[value] * (digit - 5)
		
		return five_part + non_five_part

	end

#Next we handle the second exception -- 9 digits.  These require a single 
#entry of the "value" (either C or X or I) followed by the symbol for 10 times
#the value (M or C or X).

	if digit == 9

		return roman_numeral_dict[value] + roman_numeral_dict[value*10]

	end

#Finally we handle the third exception -- 4.  Here we need a single entry
#of the value (either C or X or I) and the symbol for 5 times the value
#(D, L or V).

	if digit == 4

		return roman_numeral_dict[value] + roman_numeral_dict[value*5]

	end

#The "standard" case (0-3), where the roman numeral equals the symbol 
#for the value repeated "digit" times.

	if digit >= 0 && digit < 4

		return roman_numeral_dict[value] * digit  

	end

#If the code reaches this point, there is a problem with the digit.

	puts "Invalid digit (not 0-9).  Enter another."

end


def integer_to_roman(number)

#First we decompose the number into digits, which are then reversed.  The 
#reason to reverse them is so the first digit is always the 1's digit, regardless
#of whether it is a 1, 2, 3, or 4 digit number.  This is important in the loop
#below, which translates the number, digit-by-digit, to roman numerals, because
#the "values" passed to the digit_to_roman method above are powers of the index, 
#10^0 up to 10^3.  

number_digits = number.to_s.split('').to_a.reverse
roman_digits = []

number_digits.each_with_index{|digit, value|

#Turn the digit back to an integer to use in comparisons in digit_to_roman.

digit = digit.to_i

#Again, because the digits are reversed, the first digit (at index = 0) is
#the 1s, or 10^0, place; the second (at index = 1) is the 10s, or 10^1, etc.

value = 10 ** value

#We get the digit-by-digit translation from the method above.

roman_digits << digit_to_roman(digit, value)

}

#The output is the new array, with the digits translated.  But we need to 
#first reverse the roman digits (to read from largest to smallest) and
#then join them (so the output is a single string).

return roman_digits.reverse.join

end

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
#and the first is subtracted from the second. We do not put a comma between such letters. 

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

#We use "roman_numeral_conversion" to add the digits' values (calculated below)
#and convert to integer.

roman_numeral_conversion = 0

#The next loop goes through each separate numeral in the array and adds their value to 
#the running total.  If the numeral is two characters long, the length of the array formed
#by splitting each character is 2 and we subtract the first and add the second to the total.
#Otherwise the character is simply translated to its number equivalent and added to the total.

roman_numeral_letters.each {|numeral|

numeral = numeral.split("").to_a

if numeral.length == 1

	roman_numeral_conversion += roman_numeral_dict[numeral[0]]

else

	roman_numeral_conversion += roman_numeral_dict[numeral[1]]
	roman_numeral_conversion -= roman_numeral_dict[numeral[0]]

end

}

#Finally we return the total value of all separate roman numerals.

return roman_numeral_conversion

end

#The following method combines the functions above with a test to determine 
#what format a number is to provide the conversion for either Roman numerals or 
#for integers.

def number_converter(number)

if number.is_a?(String)

	conversion = roman_numeral_to_integer(number)

	puts "Your number is a Roman numeral.  It is equivalent to the integer #{conversion}."

	elsif number.is_a?(Integer)

	conversion = integer_to_roman(number)

	puts "Your number is an integer.  It is equivalent to the Roman numeral #{conversion}."

	else

		puts "Your number is neither an integer nor a Roman numeral.  Try again."

end

end

