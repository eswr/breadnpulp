module ApplicationHelper

	require 'net/http'
	Time.zone = 'Chennai'

	# Returns the full title on a per-page basis.       # Documentation comment
	def full_title(page_title = '')                     # Method def, optional arg
		base_title = "breadnpulp"  # Variable assignment
		if page_title.empty?                              # Boolean test
	  		base_title                                      # Implicit return
		else
	  		page_title + " | " + base_title                 # String concatenation
		end
	end

	def active_menu_date
		current_time = Time.zone
		if (current_time.now.hour == 11 && current_time.now.min < 15) || (current_time.now.hour < 11)
			current_time
		else
			current_time.tomorrow
		end	
	end

	def dayify(date)
		if date == Time.zone.today
			"Today's Menu"
		elsif date == Time.zone.tomorrow
			"Tomorrow's Menu"
		else
			"Next"
		end
	end

end