class StaticPagesController < ApplicationController
	def home
		@menus = menus_on(active_menu_date)
	end

	def active_menu_date
		Time.zone = 'Chennai'
		Time.now.hour < 12 ? Date.today : Date.tomorrow
	end
end
