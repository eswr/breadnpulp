module MenusHelper

	def menus_on(date)
		Menu.where(available_on: date).order(updated_at: :asc).eager_load(:kickerr)
	end

	def available_menus
		menus_on(active_menu_date)
	end

end
