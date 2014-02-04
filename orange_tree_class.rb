class OrangeTree

	def initialize

		@height = 0
		@age = 0
		@life_span = 10 + rand(10)
		@oranges = 0
		@living = true

	end

	def one_year_passes

		if @living == true

			@age += 1
			@height += 1

			if @age > 4

				@rate_of_growth = (@age - 4) ** 1.8
				@oranges = @rate_of_growth.to_i

			end

		elsif @living == false && @height > 0

				@height -=1

		else

			puts "Your tree has gone back into the ground.  The circle of life, etc., etc."

		end

		if @age == @life_span

			puts "Your tree has died at #{@age} years of age.  My condolences."

			@living = false
			@age = nil
			@oranges = 0

		end

	end

	def count_the_oranges

		@oranges

	end

	def measure_the_height

		@height

	end

	def pick_an_orange

		if @living == false

			puts "There are no oranges on a dead tree!"

		elsif @oranges == 0

			puts "There are no oranges! Did you pick them all?"

		else

			puts "Mmm....  Delicious and juicy!"
			@oranges -= 1

		end

	end

	end
