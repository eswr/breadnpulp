module DeliveriesHelper
	
	def available_slots
		time_now = Time.zone.now.at_beginning_of_minute
		first_slot = Time.new(active_menu_date.year, active_menu_date.month, active_menu_date.day, 7, 30, 0, "+05:30")
		last_slot = Time.new(active_menu_date.year, active_menu_date.month, active_menu_date.day, 11, 30, 0, "+05:30")
		# empty time slots
		slots = []
		# getting first available slot
		slot = get_first_slot time_now if time_now > first_slot - 45.minutes else slot = first_slot
		loop do
			slots << slot
			slot += 15.minutes
			break if slot > last_slot
		end
		slots
	end

	private

		def get_first_slot(time)
			time = time - (time.min % 15).minutes + 1.hour
		end

		def active_menu_date
			Time.zone = 'Chennai'
			current_time = Time.zone
			if (current_time.now.hour == 11 && current_time.now.min < 15) || (current_time.now.hour < 11)
				current_time.today
			else
				current_time.tomorrow
			end	
		end
end