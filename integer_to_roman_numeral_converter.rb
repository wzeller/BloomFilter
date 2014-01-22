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

