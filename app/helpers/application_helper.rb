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
		Time.zone.now.hour < 11 ? Time.zone.today : Time.zone.tomorrow
	end

	def dayify(date)
		if date == Time.zone.today
			"Today's Breakfast"
		elsif date == Time.zone.tomorrow
			"Tomorrow's Breakfast"
		else
			"Next"
		end
	end

end