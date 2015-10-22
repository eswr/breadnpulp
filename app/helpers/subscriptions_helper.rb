module SubscriptionsHelper
	def available_slots
		slot = Time.new(1, 1, 1, 8, 15, 0)
		last_slot = Time.new(1, 1, 1, 11, 45, 0)
		# empty time slots
		slots = []
		loop do
			slots << slot
			slot += 15.minutes
			break if slot > last_slot
		end
		slots
	end
end
