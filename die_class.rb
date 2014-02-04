class Die

	def initialize

		roll

	end

	def sides_showing

		possible_sides =* (1..6)
		not_showing = [@number_showing, @hidden]
		@sides_showing = possible_sides - not_showing

	end

	def hidden

		@hidden = 7 - @number_showing

	end

	def roll

		@number_showing = 1 + rand(6)
		
	end

	def showing

		@number_showing

	end

	def cheat(number)

		if number <= 6 && number >= 1 && number == number.to_i

			@number_showing = number

		else

			puts "You can't even cheat!"
			roll
			puts @number_showing

		end

	end

end
