class StaticPagesController < ApplicationController
	def home
		@menus = menus_on(active_menu_date)
		@date = active_menu_date
	end

	def active_menu_date
		Time.zone = 'Chennai'
		Time.now.hour < 11 ? Time.now.to_date : Time.now.to_date.tomorrow
	end
end
