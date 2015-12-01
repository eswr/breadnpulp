class StaticPagesController < ApplicationController
	def home
		@menus = Menu.where(available_on: active_menu_date).eager_load(:kickerr).map { |menu| [menu, menu.kickerr.name] }
		@menus.each do |menu|
			menu.kickerr_name = menu.get_kickerr_name
		end
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
