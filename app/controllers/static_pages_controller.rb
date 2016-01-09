class StaticPagesController < ApplicationController
	def home
		@menus = Menu.where(available_on: active_menu_date).eager_load(:kickerr).map
		@menus.each do |menu|
			menu.kickerr_name = menu.get_kickerr_name
		end
		@date = active_menu_date
		@meta_description = "Healthy and delicious breakfast meals delivered to your doorstep everyday. Currently operating in Powai, Hiranandani, Chandivali, Andheri East, Sakinaka and Marol"
	end

	def about
		
	end

	def active_menu_date
		Time.zone = 'Chennai'
		current_time = Time.zone
		if (current_time.now.hour == 11 && current_time.now.min < 15) || (current_time.now.hour < 11)
			current_time
		else
			current_time.tomorrow
		end	
	end

	def operator_view

	end
end
