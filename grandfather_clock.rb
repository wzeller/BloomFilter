def grandfather_clock &block_to_exec_hours_times

	hours = (Time.new.hour)%12

	hours.times {block_to_exec_hours_times.call}

end

grandfather_clock do 

puts "Dong!"

end

