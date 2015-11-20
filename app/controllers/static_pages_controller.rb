class StaticPagesController < ApplicationController
	def home
		@menus = menus_on(active_menu_date)
		@date = active_menu_date
		@user = current_user
	end

	def about
		
	end

	def active_menu_date
		Time.zone = 'Chennai'
		Time.zone.now.hour < 11 ? Time.zone.now.to_date : Time.zone.now.to_date.tomorrow
	end
end
