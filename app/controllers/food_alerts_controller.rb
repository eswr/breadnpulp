class FoodAlertsController < ApplicationController

	def edit
		@food_alert = FoodAlert.find(params[:id])
	end

	def update
		@food_alert = FoodAlert.find(params[:id])
		if @food_alert.update_attributes(food_alert_params)
			flash[:success] = "Food Alert updated!!"
			redirect_to @food_alert.user
		else
			flash[:danger] = "Food Alert not updated, please try again"
			render 'edit'
		end
	end

	def index
		@food_alerts = FoodAlert.get_food_alerts
		user_ids = @food_alerts.map{ |key, value| key }.uniq
		@users = User.get_from_ids(user_ids)
	end

	def show
	end

	private

		def food_alert_params
			params.require(:food_alert).permit(:user_id, food_item_ids: [])
		end
end
