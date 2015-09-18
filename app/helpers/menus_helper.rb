module MenusHelper

	def menus_on(date)
		Menu.where(available_on: date)
	end

	def active_menu_date
		Time.now.hour < 10 ? Date.today : Date.tomorrow
	end

	def available_menus
		menus_on(active_menu_date)
	end

end
