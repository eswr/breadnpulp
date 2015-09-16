module MenusHelper

	def menus_on(date)
		Menu.where(available_on: date)
	end

end
