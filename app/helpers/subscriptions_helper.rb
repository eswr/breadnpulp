module SubscriptionsHelper
	
	def available_slots
		slot = Time.new(active_menu_date.year, active_menu_date.month, active_menu_date.day, 7, 30, 0, "+05:30")
		last_slot = Time.new(active_menu_date.year, active_menu_date.month, active_menu_date.day, 11, 30, 0, "+05:30")
		# empty time slots
		slots = []
		# getting first available slot
		slot = get_first_slot Time.zone.now.at_beginning_of_minute if Time.zone.now > slot - 45.minutes
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
			Time.zone.now.hour < 11 ? Time.zone.today : Time.zone.tomorrow
		end
end
