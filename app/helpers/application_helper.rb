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
		Time.current.hour < 12 ? Date.today : Date.tomorrow
	end

	def active_day(date)
		if date == Date.today
			"Today's"
		elsif date == Date.tomorrow
			"Tomorrow's"
		else
			"Next"
		end
	end
end