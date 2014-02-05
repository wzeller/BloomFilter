$logger_depth = 0

def program_logger description, &block

	prefix = '   ' * $logger_depth

	puts "#{prefix}Beginning #{description}..."

	$logger_depth += 1
	time_start = Time.new

	result = block.call
	duration = Time.new - time_start
	$logger_depth -= 1

	puts "#{prefix}...#{description} finished, returning -- #{result} -- in #{duration} seconds."

end

program_logger 'counter' { 

	program_logger 'stepping' {

		program_logger 'fact' {
			
			"put".downcase

		}

		569

	}
	
	'what?'

}


