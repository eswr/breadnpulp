class StaticPagesController < ApplicationController
	def home
		@menus = menus_on(active_menu_date)
	end

	def active_menu_date
		Time.now.hour + 5 < 11 ? Date.today : Date.tomorrow
	end
end
