module ApplicationHelper

	require 'net/http'

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
		Time.zone = "Chennai"
		Time.current.hour < 11 ? Time.now.to_date : Date.tomorrow
	end

	def active_day(date)
		if date == Time.now.to_date
			"Today's"
		elsif date == Time.now.to_date.tomorrow
			"Tomorrow's"
		else
			"Next"
		end
	end

end